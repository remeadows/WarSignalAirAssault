import SwiftUI
import RealityKit
import simd

/// GameCoordinator bridges SwiftUI UI with RealityKit game world
/// This is the central hub for game state that UI can observe
///
/// Usage:
/// ```swift
/// @State private var coordinator = GameCoordinator()
/// // or inject via environment
/// .environment(coordinator)
/// ```
@Observable
@MainActor
final class GameCoordinator {

    // MARK: - Game Lifecycle

    enum GamePhase {
        case loading
        case ready
        case playing
        case paused
        case missionComplete
        case missionFailed
    }

    var gamePhase: GamePhase = .loading
    var isPaused: Bool { gamePhase == .paused }
    var isPlaying: Bool { gamePhase == .playing }

    // MARK: - Player State

    var playerHealth: Int = 100
    var playerMaxHealth: Int = 100
    var shieldHealth: Int = 100
    var shieldMaxHealth: Int = 100

    /// Time since last damage for shield regen delay
    var timeSinceLastDamage: TimeInterval = 0
    /// Delay before shield starts regenerating
    let shieldRegenDelay: TimeInterval = 3.0
    /// Shield regeneration rate (points per second)
    let shieldRegenRate: Float = 10.0

    /// Visual damage feedback - triggers red flash
    var showDamageFlash: Bool = false
    var damageFlashTimer: TimeInterval = 0

    var isPlayerAlive: Bool { playerHealth > 0 }
    var healthPercent: Float { Float(playerHealth) / Float(playerMaxHealth) }
    var shieldPercent: Float { Float(shieldHealth) / Float(shieldMaxHealth) }

    // MARK: - Weapon State

    var currentWeapon: WeaponType = .autocannon
    var ammo: [WeaponType: Int] = [
        .autocannon: 999,  // Unlimited
        .rockets: 12,
        .heavyGun: 50,
        .emp: 3
    ]
    var isOverheated: Bool = false
    var heatLevel: Float = 0.0 // 0.0 to 1.0

    var currentAmmo: Int {
        ammo[currentWeapon] ?? 0
    }

    var canFire: Bool {
        !isOverheated && currentAmmo > 0 && isPlaying
    }

    // MARK: - Aiming

    var aimPosition: SIMD3<Float> = .zero
    var aimScreenPosition: CGPoint = .zero
    var isFiring: Bool = false
    var hasValidTarget: Bool = false

    // MARK: - Mission State

    var missionTime: TimeInterval = 0
    var missionTimeLimit: TimeInterval = 180 // 3 minutes default
    var score: Int = 0
    var enemiesKilled: Int = 0
    var objectivesCompleted: Int = 0
    var objectivesTotal: Int = 1

    var missionTimeRemaining: TimeInterval {
        max(0, missionTimeLimit - missionTime)
    }

    var missionProgress: Float {
        guard objectivesTotal > 0 else { return 0 }
        return Float(objectivesCompleted) / Float(objectivesTotal)
    }

    // MARK: - Debug

    var showDebugOverlay: Bool = false
    var entityCount: Int = 0
    var fps: Double = 60.0
    var activeProjectiles: Int = 0

    // MARK: - RealityKit Scene Reference

    /// Root entity for the game scene - set by GameView
    /// Used for adding/removing entities dynamically
    var rootEntity: Entity?

    /// Camera controller for managing game camera
    var cameraController: CameraController?

    /// Reticle controller for targeting
    var reticleController: ReticleController?

    /// Weapon system for firing and projectiles
    var weaponSystem: WeaponSystem?

    /// Enemy system for managing enemies
    var enemySystem: EnemySystem?

    /// Audio system for sound effects and music
    var audioSystem: AudioSystem?

    /// Current camera zoom level (for HUD display)
    var currentZoomLevel: Int { cameraController?.currentZoomLevel ?? 1 }

    // MARK: - Initialization

    init() {
        gamePhase = .ready
        cameraController = CameraController()
        reticleController = ReticleController()
        weaponSystem = WeaponSystem()
        enemySystem = EnemySystem()
        audioSystem = AudioSystem()
        audioSystem?.start()
    }

    // MARK: - Game Lifecycle Actions

    func startMission() {
        // Reset player state
        playerHealth = playerMaxHealth
        shieldHealth = shieldMaxHealth

        // Reset weapon state
        heatLevel = 0
        isOverheated = false
        isFiring = false

        // Reset mission state
        missionTime = 0
        score = 0
        enemiesKilled = 0
        objectivesCompleted = 0

        // Reset ammo
        ammo[.rockets] = 12
        ammo[.heavyGun] = 50
        ammo[.emp] = 3

        // Start ambient audio
        audioSystem?.startAmbient(.ambientEngine)

        gamePhase = .playing
    }

    func pauseGame() {
        guard gamePhase == .playing else { return }
        gamePhase = .paused
        isFiring = false
    }

    func resumeGame() {
        guard gamePhase == .paused else { return }
        gamePhase = .playing
    }

    func endMission(success: Bool) {
        isFiring = false
        audioSystem?.stopAmbient()
        gamePhase = success ? .missionComplete : .missionFailed
    }

    // MARK: - Per-Frame Update

    /// Called every frame from RealityView update closure
    func update(deltaTime: TimeInterval) {
        guard isPlaying else { return }

        // Update mission timer
        missionTime += deltaTime

        // Check time limit
        if missionTime >= missionTimeLimit {
            endMission(success: false)
            return
        }

        // Handle weapon heat
        if isFiring {
            addHeat(Float(deltaTime) * currentWeapon.heatPerSecond)
        } else {
            coolDown(Float(deltaTime) * 0.3) // Cool down when not firing
        }

        // Update damage cooldown
        timeSinceLastDamage += deltaTime

        // Handle damage flash
        if showDamageFlash {
            damageFlashTimer += deltaTime
            if damageFlashTimer >= 0.15 {
                showDamageFlash = false
                damageFlashTimer = 0
            }
        }

        // Regenerate shield after delay
        if shieldHealth < shieldMaxHealth && timeSinceLastDamage >= shieldRegenDelay {
            let regenAmount = Float(deltaTime) * shieldRegenRate
            shieldHealth = min(shieldMaxHealth, shieldHealth + Int(regenAmount.rounded(.up)))
        }

        // Check player death
        if !isPlayerAlive {
            endMission(success: false)
        }

        // Check mission complete
        if objectivesCompleted >= objectivesTotal {
            endMission(success: true)
        }

        // Update weapon system
        weaponSystem?.update(deltaTime: Float(deltaTime))

        // Update enemy system
        enemySystem?.update(deltaTime: Float(deltaTime))

        // Update entity count for debug
        entityCount = (enemySystem?.enemyCount ?? 0) + activeProjectiles
    }

    // MARK: - Aiming Actions

    func updateAimPosition(_ worldPosition: SIMD3<Float>) {
        aimPosition = worldPosition
        // Update reticle position
        reticleController?.setPosition(worldPosition)
    }

    func updateAimScreenPosition(_ screenPosition: CGPoint) {
        aimScreenPosition = screenPosition
    }

    /// Shows the targeting reticle (kept for compatibility, reticle is always visible now)
    func showReticle() {
        reticleController?.isVisible = true
    }

    /// Hides the targeting reticle (kept for compatibility, but reticle stays visible in WS-023)
    func hideReticle() {
        // Reticle stays visible per WS-023 - always on during gameplay
        // reticleController?.hide() -- disabled
    }

    /// Ensures reticle is visible and positioned (call on mission start)
    func initializeReticle(at position: SIMD3<Float>) {
        reticleController?.setPosition(position)
        reticleController?.isVisible = true
    }

    /// Updates reticle animation
    func updateReticle(deltaTime: Float) {
        reticleController?.update(deltaTime: deltaTime)
    }

    /// Sets whether reticle is over a valid target
    func setReticleTargetState(_ hasTarget: Bool) {
        hasValidTarget = hasTarget
        reticleController?.hasValidTarget = hasTarget
    }

    // MARK: - Firing Actions

    func startFiring() {
        guard canFire else { return }
        isFiring = true
    }

    func stopFiring() {
        isFiring = false
    }

    /// Called when a projectile is actually fired
    func consumeAmmo() {
        guard let current = ammo[currentWeapon], current > 0 else { return }
        if currentWeapon != .autocannon { // Autocannon has unlimited ammo
            ammo[currentWeapon] = current - 1
        }
    }

    // MARK: - Weapon Selection

    func selectWeapon(_ weapon: WeaponType) {
        guard weapon != currentWeapon else { return }
        stopFiring() // Stop firing when switching
        currentWeapon = weapon
        heatLevel = 0 // Reset heat on weapon switch
        isOverheated = false
    }

    func cycleWeapon() {
        let weapons = WeaponType.allCases
        guard let currentIndex = weapons.firstIndex(of: currentWeapon) else { return }
        let nextIndex = (currentIndex + 1) % weapons.count
        selectWeapon(weapons[nextIndex])
    }

    // MARK: - Damage System

    func applyDamage(_ amount: Int) {
        guard isPlaying else { return }

        // Reset damage cooldown
        timeSinceLastDamage = 0

        // Trigger visual feedback
        showDamageFlash = true
        damageFlashTimer = 0

        // Trigger camera shake for damage
        cameraController?.shake(intensity: 0.15, duration: 0.2)

        // Play damage sound
        if shieldHealth > 0 {
            audioSystem?.play(.impactSmall) // Shield absorb sound
        } else {
            audioSystem?.play(.impactLarge) // Hull damage sound
        }

        // Shield absorbs damage first
        if shieldHealth > 0 {
            let shieldDamage = min(amount, shieldHealth)
            shieldHealth -= shieldDamage
            let remainingDamage = amount - shieldDamage
            if remainingDamage > 0 {
                playerHealth = max(0, playerHealth - remainingDamage)
            }
        } else {
            playerHealth = max(0, playerHealth - amount)
        }
    }

    func heal(_ amount: Int) {
        playerHealth = min(playerMaxHealth, playerHealth + amount)
    }

    func restoreShield(_ amount: Int) {
        shieldHealth = min(shieldMaxHealth, shieldHealth + amount)
    }

    // MARK: - Heat System

    func addHeat(_ amount: Float) {
        heatLevel = min(1.0, heatLevel + amount)
        if heatLevel >= 1.0 {
            isOverheated = true
            isFiring = false
        }
    }

    func coolDown(_ amount: Float) {
        heatLevel = max(0.0, heatLevel - amount)
        if heatLevel <= 0.3 && isOverheated {
            isOverheated = false
        }
    }

    // MARK: - Scoring

    func addScore(_ points: Int) {
        score += points
    }

    func recordKill() {
        enemiesKilled += 1
        addScore(100) // Base score per kill
    }

    func completeObjective() {
        objectivesCompleted += 1
        addScore(500) // Bonus for objective
    }

    // MARK: - Camera Control

    /// Cycles through zoom levels
    func cycleZoom() {
        cameraController?.cycleZoom()
    }

    /// Sets specific zoom level
    func setZoomLevel(_ level: Int) {
        cameraController?.setZoomLevel(level)
    }

    /// Triggers camera shake for current weapon
    func triggerWeaponShake() {
        cameraController?.shakeForWeapon(currentWeapon.rawValue.lowercased())
    }

    /// Updates camera each frame
    func updateCamera(deltaTime: Float) {
        cameraController?.update(deltaTime: deltaTime)
    }
}

// MARK: - Weapon Type

/// Available weapon types with their properties
enum WeaponType: String, CaseIterable, Identifiable {
    case autocannon = "Autocannon"
    case rockets = "Rockets"
    case heavyGun = "Heavy Gun"
    case emp = "EMP Burst"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .autocannon: return "flame.fill"
        case .rockets: return "airplane"
        case .heavyGun: return "bolt.fill"
        case .emp: return "bolt.circle.fill"
        }
    }

    /// Short name for HUD display
    var shortName: String {
        switch self {
        case .autocannon: return "AUTO"
        case .rockets: return "ROCKETS"
        case .heavyGun: return "HEAVY"
        case .emp: return "EMP"
        }
    }

    /// Rounds per second
    var fireRate: Float {
        switch self {
        case .autocannon: return 12.0
        case .rockets: return 1.0
        case .heavyGun: return 2.0
        case .emp: return 0.5
        }
    }

    /// Damage per hit
    var damage: Int {
        switch self {
        case .autocannon: return 10
        case .rockets: return 80
        case .heavyGun: return 50
        case .emp: return 30
        }
    }

    /// Splash radius (0 = no splash)
    var splashRadius: Float {
        switch self {
        case .autocannon: return 0
        case .rockets: return 3.0
        case .heavyGun: return 0.5
        case .emp: return 8.0
        }
    }

    /// Heat generated per second while firing
    var heatPerSecond: Float {
        switch self {
        case .autocannon: return 0.15
        case .rockets: return 0.3
        case .heavyGun: return 0.25
        case .emp: return 0.5
        }
    }

    /// Projectile speed
    var projectileSpeed: Float {
        switch self {
        case .autocannon: return 50.0
        case .rockets: return 20.0
        case .heavyGun: return 80.0
        case .emp: return 15.0
        }
    }

    /// HUD color for weapon (cyberpunk palette)
    var hudColor: Color {
        switch self {
        case .autocannon: return .orange
        case .rockets: return .red
        case .heavyGun: return .cyan
        case .emp: return .purple
        }
    }
}

// MARK: - Environment Key

/// Environment key for GameCoordinator
private struct GameCoordinatorKey: EnvironmentKey {
    static let defaultValue: GameCoordinator? = nil
}

extension EnvironmentValues {
    var gameCoordinator: GameCoordinator? {
        get { self[GameCoordinatorKey.self] }
        set { self[GameCoordinatorKey.self] = newValue }
    }
}

extension View {
    func gameCoordinator(_ coordinator: GameCoordinator) -> some View {
        environment(\.gameCoordinator, coordinator)
    }
}
