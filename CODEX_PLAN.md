# CODEX_PLAN.md

## 1. Understanding

WarSignal needs utility infrastructure that is stable under failure because every gameplay system depends on it.

- Config loading controls balance, AI, and progression tuning without code edits.
- Save integrity protects long-term player trust; corruption is a hard product risk.
- Shared protocols keep SceneKit entities consistent with the fixed game-loop contract.
- Constants and formatting utilities prevent duplicated logic across engine, HUD, and progression.
- Debug utilities make frame-time and entity-limit regressions visible early.

My approach is to build defensive utilities first: strict decode + validation, safe fallbacks, explicit logging, versioned save migrations, and predictable pool behavior under pressure.

## 2. ConfigLoader Design

### API Surface

```swift
import Foundation
import OSLog

protocol ConfigValidatable {
    func validate() throws
}

enum ConfigLoaderError: Error {
    case missingResource(String)
    case decodeFailed(String)
    case validationFailed(String)
}

final class ConfigLoader {
    private let decoder: JSONDecoder
    private let logger: Logger

    init(
        decoder: JSONDecoder = JSONDecoder(),
        logger: Logger = Logger(subsystem: "com.warsignal.app", category: "ConfigLoader")
    ) {
        self.decoder = decoder
        self.logger = logger
    }

    func load<T: Decodable & ConfigValidatable>(
        _ type: T.Type,
        resource: String,
        bundle: Bundle = .main,
        subdirectory: String? = "config",
        fallback: @autoclosure () -> T
    ) -> T {
        do {
            let config = try loadRequired(type, resource: resource, bundle: bundle, subdirectory: subdirectory)
            return config
        } catch {
            logger.error("Config load failed for \(resource, privacy: .public): \(String(describing: error), privacy: .public)")
            return fallback()
        }
    }

    func loadRequired<T: Decodable & ConfigValidatable>(
        _ type: T.Type,
        resource: String,
        bundle: Bundle = .main,
        subdirectory: String? = "config"
    ) throws -> T {
        guard let url = bundle.url(forResource: resource, withExtension: "json", subdirectory: subdirectory) else {
            throw ConfigLoaderError.missingResource(resource)
        }

        let data = try Data(contentsOf: url)

        let decoded: T
        do {
            decoded = try decoder.decode(T.self, from: data)
        } catch {
            throw ConfigLoaderError.decodeFailed(resource)
        }

        do {
            try decoded.validate()
        } catch {
            throw ConfigLoaderError.validationFailed(resource)
        }

        return decoded
    }
}
```

### Usage Example (Weapon System)

```swift
import Foundation

struct WeaponCatalog: Codable, ConfigValidatable {
    struct WeaponStats: Codable {
        let id: String
        let displayName: String
        let damage: Double
        let fireRate: Double
        let projectileSpeed: Double
        let maxAmmo: Int
        let splashRadius: Double
    }

    let schemaVersion: Int
    let weapons: [WeaponStats]

    static let `default` = WeaponCatalog(
        schemaVersion: 1,
        weapons: [
            WeaponStats(
                id: "vulcan",
                displayName: "Vulcan",
                damage: 8,
                fireRate: 16,
                projectileSpeed: 190,
                maxAmmo: 500,
                splashRadius: 0
            )
        ]
    )

    func validate() throws {
        guard schemaVersion >= 1 else { throw ValidationError.invalidSchema }
        guard !weapons.isEmpty else { throw ValidationError.emptyList }
        guard weapons.allSatisfy({ $0.damage > 0 && $0.fireRate > 0 && $0.maxAmmo > 0 }) else {
            throw ValidationError.outOfRange
        }
    }

    enum ValidationError: Error {
        case invalidSchema
        case emptyList
        case outOfRange
    }
}

let loader = ConfigLoader()
let weaponCatalog = loader.load(WeaponCatalog.self, resource: "weapons", fallback: WeaponCatalog.default)
```

### GameConstants Integration

```swift
import Foundation
import Observation

@Observable
@MainActor
final class GameConstants {
    private(set) var weaponCatalog: WeaponCatalog = .default
    private let loader: ConfigLoader

    init(loader: ConfigLoader = ConfigLoader()) {
        self.loader = loader
        reload()
    }

    func reload(bundle: Bundle = .main) {
        weaponCatalog = loader.load(
            WeaponCatalog.self,
            resource: "weapons",
            bundle: bundle,
            fallback: WeaponCatalog.default
        )
    }
}
```

## 3. SaveManager Design

### API Surface

```swift
import Foundation
import OSLog

protocol SavePayload: Codable {
    static var currentVersion: Int { get }
    static var defaultValue: Self { get }
    func validate() throws
}

struct SaveEnvelope: Codable {
    let version: Int
    let savedAt: Date
    let payload: Data
}

struct SaveMigrationStep {
    let fromVersion: Int
    let toVersion: Int
    let migrate: (Data, JSONDecoder, JSONEncoder) throws -> Data
}

enum SaveLoadSource {
    case primary
    case backup
    case defaults
}

final class SaveManager<Payload: SavePayload> {
    private let userDefaults: UserDefaults
    private let primaryKey: String
    private let backupKey: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let logger: Logger
    private let migrationSteps: [SaveMigrationStep]

    init(
        userDefaults: UserDefaults = .standard,
        primaryKey: String = "save.primary",
        backupKey: String = "save.backup",
        migrationSteps: [SaveMigrationStep] = [],
        logger: Logger = Logger(subsystem: "com.warsignal.app", category: "SaveManager")
    ) {
        self.userDefaults = userDefaults
        self.primaryKey = primaryKey
        self.backupKey = backupKey
        self.migrationSteps = migrationSteps
        self.logger = logger

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        self.encoder = encoder

        self.decoder = JSONDecoder()
    }

    @discardableResult
    func save(_ payload: Payload) -> Bool {
        do {
            try payload.validate()
            let payloadData = try encoder.encode(payload)
            let envelope = SaveEnvelope(
                version: Payload.currentVersion,
                savedAt: Date(),
                payload: payloadData
            )
            let encodedEnvelope = try encoder.encode(envelope)

            if let currentData = userDefaults.data(forKey: primaryKey) {
                userDefaults.set(currentData, forKey: backupKey)
            }

            userDefaults.set(encodedEnvelope, forKey: primaryKey)
            return true
        } catch {
            logger.error("Save write failed: \(String(describing: error), privacy: .public)")
            return false
        }
    }

    func load() -> (payload: Payload, source: SaveLoadSource) {
        if let payload = tryLoad(fromKey: primaryKey) {
            return (payload, .primary)
        }

        if let payload = tryLoad(fromKey: backupKey) {
            logger.warning("Primary save invalid; recovered from backup")
            return (payload, .backup)
        }

        logger.error("No valid save found; using defaults")
        return (Payload.defaultValue, .defaults)
    }

    func clearAll() {
        userDefaults.removeObject(forKey: primaryKey)
        userDefaults.removeObject(forKey: backupKey)
    }

    private func tryLoad(fromKey key: String) -> Payload? {
        guard let data = userDefaults.data(forKey: key) else { return nil }

        do {
            let envelope = try decoder.decode(SaveEnvelope.self, from: data)
            let migratedData = try migrateIfNeeded(envelope.payload, from: envelope.version)
            let payload = try decoder.decode(Payload.self, from: migratedData)
            try payload.validate()
            return payload
        } catch {
            logger.error("Save load failed for key \(key, privacy: .public): \(String(describing: error), privacy: .public)")
            return nil
        }
    }

    private func migrateIfNeeded(_ data: Data, from version: Int) throws -> Data {
        guard version < Payload.currentVersion else { return data }

        var currentVersion = version
        var currentData = data

        while currentVersion < Payload.currentVersion {
            guard let step = migrationSteps.first(where: { $0.fromVersion == currentVersion }) else {
                throw MigrationError.missingStep(from: currentVersion)
            }

            currentData = try step.migrate(currentData, decoder, encoder)
            currentVersion = step.toVersion
        }

        return currentData
    }

    enum MigrationError: Error {
        case missingStep(from: Int)
    }
}
```

### SaveData and Migration Interface

```swift
import Foundation

struct SaveData: SavePayload {
    static let currentVersion: Int = 2

    var credits: Int
    var levelsUnlocked: Int
    var levelStars: [Int: Int]

    var vulcanAmmoTier: Int
    var vulcanDamageTier: Int
    var vulcanOverheatTier: Int
    var havocAmmoTier: Int
    var havocSplashTier: Int
    var havocReloadTier: Int
    var reaperAmmoTier: Int
    var reaperDamageTier: Int
    var reaperTrackingUnlocked: Bool

    var hullTier: Int
    var flareTier: Int
    var flareRechargeTier: Int
    var ecmTier: Int
    var hullRepairUnlocked: Bool

    var armorTier: Int
    var weaponsTier: Int
    var medicTier: Int
    var droneUnlocked: Bool
    var apcUnlocked: Bool

    static let defaultValue = SaveData(
        credits: 0,
        levelsUnlocked: 1,
        levelStars: [:],
        vulcanAmmoTier: 0,
        vulcanDamageTier: 0,
        vulcanOverheatTier: 0,
        havocAmmoTier: 0,
        havocSplashTier: 0,
        havocReloadTier: 0,
        reaperAmmoTier: 0,
        reaperDamageTier: 0,
        reaperTrackingUnlocked: false,
        hullTier: 0,
        flareTier: 0,
        flareRechargeTier: 0,
        ecmTier: 0,
        hullRepairUnlocked: false,
        armorTier: 0,
        weaponsTier: 0,
        medicTier: 0,
        droneUnlocked: false,
        apcUnlocked: false
    )

    func validate() throws {
        guard credits >= 0 else { throw ValidationError.negativeCredits }
        guard (1...10).contains(levelsUnlocked) else { throw ValidationError.invalidLevelUnlock }
        guard levelStars.values.allSatisfy({ (0...3).contains($0) }) else { throw ValidationError.invalidStars }
    }

    enum ValidationError: Error {
        case negativeCredits
        case invalidLevelUnlock
        case invalidStars
    }
}

struct SaveDataV1: Codable {
    var credits: Int
    var levelsUnlocked: Int
    var levelStars: [Int: Int]

    var vulcanAmmoTier: Int
    var vulcanDamageTier: Int
    var vulcanOverheatTier: Int
    var havocAmmoTier: Int
    var havocSplashTier: Int
    var havocReloadTier: Int
    var reaperAmmoTier: Int
    var reaperDamageTier: Int
    var reaperTrackingUnlocked: Bool

    var hullTier: Int
    var flareTier: Int
    var flareRechargeTier: Int
    var ecmTier: Int
    var hullRepairUnlocked: Bool

    var armorTier: Int
    var weaponsTier: Int
    var medicTier: Int
    var droneUnlocked: Bool
}

enum SaveDataMigrations {
    static let steps: [SaveMigrationStep] = [
        SaveMigrationStep(fromVersion: 1, toVersion: 2) { data, decoder, encoder in
            let old = try decoder.decode(SaveDataV1.self, from: data)
            let migrated = SaveData(
                credits: old.credits,
                levelsUnlocked: old.levelsUnlocked,
                levelStars: old.levelStars,
                vulcanAmmoTier: old.vulcanAmmoTier,
                vulcanDamageTier: old.vulcanDamageTier,
                vulcanOverheatTier: old.vulcanOverheatTier,
                havocAmmoTier: old.havocAmmoTier,
                havocSplashTier: old.havocSplashTier,
                havocReloadTier: old.havocReloadTier,
                reaperAmmoTier: old.reaperAmmoTier,
                reaperDamageTier: old.reaperDamageTier,
                reaperTrackingUnlocked: old.reaperTrackingUnlocked,
                hullTier: old.hullTier,
                flareTier: old.flareTier,
                flareRechargeTier: old.flareRechargeTier,
                ecmTier: old.ecmTier,
                hullRepairUnlocked: old.hullRepairUnlocked,
                armorTier: old.armorTier,
                weaponsTier: old.weaponsTier,
                medicTier: old.medicTier,
                droneUnlocked: old.droneUnlocked,
                apcUnlocked: false
            )
            return try encoder.encode(migrated)
        }
    ]
}
```

### Usage

```swift
let saveManager = SaveManager<SaveData>(migrationSteps: SaveDataMigrations.steps)

let loadResult = saveManager.load()
var saveData = loadResult.payload

saveData.credits += 250
_ = saveManager.save(saveData)
```

## 4. Entity Protocol Design

```swift
import Foundation

protocol Updatable: AnyObject {
    func update(deltaTime: TimeInterval)
}

protocol Damageable: AnyObject {
    var health: Int { get set }
    var maxHealth: Int { get }
    var isAlive: Bool { get }

    @discardableResult
    func takeDamage(_ amount: Int) -> Bool
}

extension Damageable {
    var isAlive: Bool { health > 0 }

    @discardableResult
    func takeDamage(_ amount: Int) -> Bool {
        guard amount > 0, health > 0 else { return false }
        health = max(health - amount, 0)
        return true
    }
}

protocol Poolable: AnyObject {
    var isActive: Bool { get }
    func activate()
    func deactivate()
}

typealias CombatEntity = Updatable & Damageable
typealias PooledCombatEntity = Updatable & Damageable & Poolable
```

Yes, an entity can be `Damageable` but not `Poolable` by conforming only to `Damageable` (for example a boss node that is persistent for the whole mission).

## 5. JSON Config Schema Design

### `weapons.json` Structure

- `schemaVersion`: `Int`
- `weapons`: `[Weapon]`
- `upgradeTiers`: `[String: [UpgradeTier]]` keyed by weapon id

```json
{
  "schemaVersion": 1,
  "weapons": [
    {
      "id": "vulcan",
      "displayName": "Vulcan 20mm",
      "slot": "primary",
      "baseDamage": 8.0,
      "fireRate": 16.0,
      "projectileSpeed": 190.0,
      "maxAmmo": 500,
      "reloadSeconds": 2.0,
      "splashRadius": 0.0,
      "overheat": {
        "enabled": true,
        "heatPerShot": 1.0,
        "coolRatePerSecond": 7.0,
        "lockoutAt": 100.0
      }
    },
    {
      "id": "havoc",
      "displayName": "HAVOC Rockets",
      "slot": "secondary",
      "baseDamage": 180.0,
      "fireRate": 1.2,
      "projectileSpeed": 120.0,
      "maxAmmo": 24,
      "reloadSeconds": 4.0,
      "splashRadius": 4.0,
      "overheat": {
        "enabled": false,
        "heatPerShot": 0.0,
        "coolRatePerSecond": 0.0,
        "lockoutAt": 0.0
      }
    }
  ],
  "upgradeTiers": {
    "vulcan": [
      { "tier": 1, "cost": 500, "damageMultiplier": 1.1, "ammoBonus": 50 },
      { "tier": 2, "cost": 1200, "damageMultiplier": 1.2, "ammoBonus": 100 }
    ],
    "havoc": [
      { "tier": 1, "cost": 900, "damageMultiplier": 1.15, "ammoBonus": 2 }
    ]
  }
}
```

### `enemies.json` Structure

- `schemaVersion`: `Int`
- `enemies`: `[EnemyType]`
- `behaviorPresets`: `[String: BehaviorPreset]`

```json
{
  "schemaVersion": 1,
  "enemies": [
    {
      "id": "street_infantry",
      "class": "infantry",
      "maxHealth": 40,
      "moveSpeed": 3.5,
      "visionRadius": 20.0,
      "engageRadius": 14.0,
      "dps": 4.0,
      "armor": 0.0,
      "scoreValue": 10,
      "creditReward": 12,
      "behaviorPresetId": "rush_light"
    },
    {
      "id": "corp_turret",
      "class": "turret",
      "maxHealth": 220,
      "moveSpeed": 0.0,
      "visionRadius": 35.0,
      "engageRadius": 30.0,
      "dps": 14.0,
      "armor": 0.25,
      "scoreValue": 70,
      "creditReward": 90,
      "behaviorPresetId": "static_guard"
    }
  ],
  "behaviorPresets": {
    "rush_light": {
      "pathing": "direct",
      "retargetInterval": 0.5,
      "burstCount": 3,
      "burstCooldown": 1.2
    },
    "static_guard": {
      "pathing": "none",
      "retargetInterval": 0.25,
      "burstCount": 5,
      "burstCooldown": 2.0
    }
  }
}
```

## 6. Object Pooling Pattern (SceneKit)

```swift
import Foundation
import SceneKit
import OSLog

protocol SceneNodePoolItem: AnyObject {
    var node: SCNNode { get }
    var isActive: Bool { get set }
    func resetForReuse()
}

enum PoolExhaustionPolicy {
    case fail
    case recycleOldest
}

final class SceneNodePool<Item: SceneNodePoolItem> {
    private var items: [Item]
    private var recycleCursor: Int = 0
    private let logger: Logger

    init(
        items: [Item],
        attachTo parentNode: SCNNode,
        logger: Logger = Logger(subsystem: "com.warsignal.app", category: "SceneNodePool")
    ) {
        self.items = items
        self.logger = logger

        for item in items {
            item.isActive = false
            item.node.isHidden = true
            item.node.isPaused = true
            parentNode.addChildNode(item.node)
        }
    }

    func acquire(policy: PoolExhaustionPolicy = .fail) -> Item? {
        if let free = items.first(where: { !$0.isActive }) {
            activate(free)
            return free
        }

        guard policy == .recycleOldest, !items.isEmpty else {
            logger.error("Pool exhausted; no inactive item available")
            return nil
        }

        let recycled = items[recycleCursor]
        recycleCursor = (recycleCursor + 1) % items.count
        recycled.resetForReuse()
        activate(recycled)
        logger.warning("Pool exhausted; recycled active item")
        return recycled
    }

    func release(_ item: Item) {
        item.resetForReuse()
        item.isActive = false
        item.node.isHidden = true
        item.node.isPaused = true
        item.node.physicsBody?.clearAllForces()
        item.node.physicsBody?.velocity = SCNVector3Zero
        item.node.physicsBody?.angularVelocity = SCNVector4(0, 0, 0, 0)
    }

    var activeCount: Int {
        items.reduce(0) { $0 + ($1.isActive ? 1 : 0) }
    }

    var totalCount: Int { items.count }

    private func activate(_ item: Item) {
        item.isActive = true
        item.node.isHidden = false
        item.node.isPaused = false
    }
}
```

This follows the mandatory rule: nodes are pre-attached and never added/removed in active gameplay.

## 7. Error Handling Philosophy

- Missing or malformed config: log error, load validated hardcoded defaults, continue gameplay.
- Invalid config value ranges: reject config as a whole if critical, clamp if non-critical and log warning.
- Corrupt primary save: attempt backup save automatically.
- Corrupt primary and backup: return `SaveData.defaultValue` without crash; emit high-priority log.
- Migration gap: fail load path to backup/defaults; never attempt partial unsafe migration.
- Pool exhaustion: return `nil` for non-critical effects, optionally recycle oldest for projectiles based on policy.
- Debug visibility: all fallback paths report source (`primary`, `backup`, `defaults`) to HUD/debug overlay in debug builds.

## 8. Delivery Plan

### Batch 1 (Phase 1 Foundation)

- `ConfigLoader.swift` (generic load, validation, fallback, logging)
- `SaveManager.swift` (versioned envelope, backup-before-write, migration pipeline)
- `EntityProtocol.swift` (`Updatable`, `Damageable`, `Poolable` composition)
- `GameConstants.swift` (runtime tunables with config-backed reload)

Complexity: Medium-High. Main risk is getting migration and validation strict enough without blocking development.

### Batch 2 (Phase 2 Weapons)

- NumberFormatter extensions for credits/timer/damage
- `DebugOverlay.swift` (FPS, active entity count, physics debug toggle in `#if DEBUG`)

Complexity: Medium. Requires tight integration with renderer timing and minimal runtime overhead.

### Batch 3 (Phase 5 Progression)

- Expanded save migration table (`v1 -> v2 -> ...`) with tests
- `ConfigValidator` build script for schema checks of all JSON files

Complexity: High. Build-time validation and migration test coverage are critical for release safety.

## 9. Risks and Concerns

- SceneKit physics state can leak between pooled activations if force/velocity is not reset every release.
- SwiftUI `@Observable` state updates must stay on `@MainActor`; scene updates run per frame and need careful handoff.
- `SCNView` debug options and physics overlays can impact frame time if left enabled outside debug.
- JSON schema drift across designer tooling can silently break balance if validation is weak.
- UserDefaults is reliable for this scope, but write frequency must be controlled (checkpoint cadence, not per-frame).
- Entity cap enforcement should be visible in debug to avoid accidental performance regressions.

## 10. Questions for PM

1. Should config fallback be all-or-nothing per file, or should we merge valid records with defaults for invalid records?
2. Do we want save auto-checkpoints at mission milestones only, or also periodic in-mission snapshots?
3. For pool exhaustion in combat, should projectiles recycle oldest by default or fail-shot and preserve causality?
4. Should `levelStars` be clamped to only unlocked levels during validation, or allow pre-population for live-ops events?
5. Do you want migration tests as pure unit tests now, or deferred until Batch 3 with full fixture files?
6. Is there a target log transport beyond Xcode console (for example, persisted debug logs in TestFlight builds)?
