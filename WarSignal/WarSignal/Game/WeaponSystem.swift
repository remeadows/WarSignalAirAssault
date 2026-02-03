import RealityKit
import UIKit

/// Handles weapon firing, projectile management, and hit effects
/// Works with GameCoordinator to respond to fire commands
@MainActor
final class WeaponSystem {

    // MARK: - Properties

    /// Reference to game coordinator for state access
    private weak var coordinator: GameCoordinator?

    /// Parent entity for weapon effects
    private weak var parentEntity: Entity?

    /// Projectile pools per weapon type
    private var autocannonPool: ProjectilePool?
    private var rocketPool: ProjectilePool?
    private var heavyGunPool: ProjectilePool?

    /// Muzzle flash entity (reused)
    private var muzzleFlash: Entity?

    /// Impact spark pool
    private var impactSparks: [Entity] = []
    private var availableSparks: [Entity] = []
    private let maxSparks = 20

    /// Fire rate tracking
    private var lastFireTime: [WeaponType: Float] = [:]
    private var gameTime: Float = 0

    /// Camera position for projectile origin
    var cameraPosition: SIMD3<Float> = SIMD3<Float>(0, 25, 15)

    // MARK: - Initialization

    init() {
        // Pools created when parent entity is set
    }

    /// Sets up the weapon system with a parent entity
    func setup(parent: Entity, coordinator: GameCoordinator) {
        self.parentEntity = parent
        self.coordinator = coordinator

        // Create projectile pools
        autocannonPool = ProjectilePool(
            config: .autocannon,
            parent: parent
        )
        rocketPool = ProjectilePool(
            config: .rockets,
            parent: parent
        )
        heavyGunPool = ProjectilePool(
            config: .heavyGun,
            parent: parent
        )

        // Create muzzle flash
        createMuzzleFlash(parent: parent)

        // Create impact spark pool
        createImpactSparkPool(parent: parent)

        // Initialize fire times
        for weapon in WeaponType.allCases {
            lastFireTime[weapon] = -999 // Allow immediate first shot
        }
    }

    // MARK: - Visual Effects Setup

    private func createMuzzleFlash(parent: Entity) {
        let flash = Entity()
        flash.name = "MuzzleFlash"

        // Create a small bright sphere
        let mesh = MeshResource.generateSphere(radius: 0.3)
        var material = UnlitMaterial()
        material.color = .init(tint: UIColor(red: 1.0, green: 0.9, blue: 0.5, alpha: 1.0))
        flash.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])

        flash.isEnabled = false
        parent.addChild(flash)
        muzzleFlash = flash
    }

    private func createImpactSparkPool(parent: Entity) {
        let mesh = MeshResource.generateSphere(radius: 0.15)
        var material = UnlitMaterial()
        material.color = .init(tint: UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 1.0))

        for i in 0..<maxSparks {
            let spark = Entity()
            spark.name = "ImpactSpark_\(i)"
            spark.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])
            spark.isEnabled = false
            parent.addChild(spark)
            impactSparks.append(spark)
            availableSparks.append(spark)
        }
    }

    // MARK: - Firing

    /// Attempts to fire the current weapon
    /// Returns true if a shot was fired
    func tryFire(weapon: WeaponType, targetPosition: SIMD3<Float>) -> Bool {
        // Check fire rate
        let timeSinceLastFire = gameTime - (lastFireTime[weapon] ?? -999)
        let fireInterval = 1.0 / weapon.fireRate

        guard timeSinceLastFire >= fireInterval else {
            return false
        }

        // Get appropriate pool
        guard let pool = poolForWeapon(weapon) else {
            return false
        }

        // Calculate fire position (from camera/gunship)
        let firePosition = cameraPosition

        // Calculate direction to target
        let direction = simd_normalize(targetPosition - firePosition)

        // Acquire projectile
        guard pool.acquire(
            position: firePosition,
            direction: direction,
            weapon: weapon
        ) != nil else {
            return false
        }

        // Update fire time
        lastFireTime[weapon] = gameTime

        // Show muzzle flash
        showMuzzleFlash(at: firePosition)

        // Trigger camera shake
        coordinator?.triggerWeaponShake()

        // Play weapon sound
        coordinator?.audioSystem?.playWeaponFire(weapon)

        // Consume ammo
        coordinator?.consumeAmmo()

        return true
    }

    private func poolForWeapon(_ weapon: WeaponType) -> ProjectilePool? {
        switch weapon {
        case .autocannon:
            return autocannonPool
        case .rockets:
            return rocketPool
        case .heavyGun:
            return heavyGunPool
        case .emp:
            return nil // EMP is instant, no projectile
        }
    }

    // MARK: - Visual Effects

    private var muzzleFlashTimer: Float = 0

    private func showMuzzleFlash(at position: SIMD3<Float>) {
        guard let flash = muzzleFlash else { return }
        flash.position = position
        flash.isEnabled = true
        muzzleFlashTimer = 0.05 // Show for 50ms
    }

    private func showImpactSpark(at position: SIMD3<Float>) {
        guard !availableSparks.isEmpty else { return }

        let spark = availableSparks.removeLast()
        spark.position = position
        spark.isEnabled = true
        spark.scale = SIMD3<Float>(repeating: 1.0)

        // Schedule release after short duration
        // For now, we'll handle this in update
    }

    // MARK: - Update Loop

    /// Called every frame to update projectiles and effects
    func update(deltaTime: Float) {
        gameTime += deltaTime

        // Update muzzle flash
        if muzzleFlashTimer > 0 {
            muzzleFlashTimer -= deltaTime
            if muzzleFlashTimer <= 0 {
                muzzleFlash?.isEnabled = false
            }
        }

        // Get enemy positions for hit detection
        let enemyPositions = getEnemyPositions()

        // Update projectile pools
        updatePool(autocannonPool, deltaTime: deltaTime, enemyPositions: enemyPositions)
        updatePool(rocketPool, deltaTime: deltaTime, enemyPositions: enemyPositions)
        updatePool(heavyGunPool, deltaTime: deltaTime, enemyPositions: enemyPositions)

        // Handle continuous fire
        if let coordinator = coordinator, coordinator.isFiring && coordinator.canFire {
            let _ = tryFire(
                weapon: coordinator.currentWeapon,
                targetPosition: coordinator.aimPosition
            )
        }

        // Update coordinator stats
        updateStats()
    }

    private func getEnemyPositions() -> [(position: SIMD3<Float>, radius: Float)] {
        guard let enemySystem = coordinator?.enemySystem else { return [] }
        return enemySystem.activeEnemies.map { enemy in
            (position: enemy.position, radius: Float(0.8)) // Hit radius
        }
    }

    private func updatePool(_ pool: ProjectilePool?, deltaTime: Float, enemyPositions: [(position: SIMD3<Float>, radius: Float)]) {
        guard let pool = pool else { return }
        guard let enemySystem = coordinator?.enemySystem else {
            // No enemy system, just expire projectiles
            let expired = pool.update(deltaTime: deltaTime)
            for (entity, _, hitPosition) in expired {
                if let pos = hitPosition {
                    showImpactSpark(at: pos)
                }
                pool.release(entity)
            }
            return
        }

        let expired = pool.update(deltaTime: deltaTime, enemyPositions: enemyPositions)

        for (entity, data, hitPosition) in expired {
            // Show impact effect if hit something
            if let pos = hitPosition {
                showImpactSpark(at: pos)

                // Apply damage to nearby enemies
                let destroyed = enemySystem.checkProjectileHits(
                    projectilePosition: pos,
                    damage: data.damage,
                    splashRadius: data.splashRadius
                )

                // Process destroyed enemies
                for enemy in destroyed {
                    enemySystem.destroyEnemy(enemy)
                    // Play explosion sound on kill
                    coordinator?.audioSystem?.playExplosion()
                }

                // Play impact sound if we hit something
                if !destroyed.isEmpty || data.splashRadius > 0 {
                    coordinator?.audioSystem?.playImpact(large: data.splashRadius > 1.0)
                }
            }

            pool.release(entity)
        }
    }

    private func updateStats() {
        let activeCount = (autocannonPool?.activeCount ?? 0) +
                         (rocketPool?.activeCount ?? 0) +
                         (heavyGunPool?.activeCount ?? 0)
        coordinator?.activeProjectiles = activeCount
    }

    // MARK: - Cleanup

    /// Releases all active projectiles
    func reset() {
        autocannonPool?.releaseAll()
        rocketPool?.releaseAll()
        heavyGunPool?.releaseAll()
        muzzleFlash?.isEnabled = false
        gameTime = 0
        for weapon in WeaponType.allCases {
            lastFireTime[weapon] = -999
        }
    }
}
