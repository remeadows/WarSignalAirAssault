import RealityKit
import UIKit

/// Manages enemy entities, damage detection, and destruction effects
@MainActor
final class EnemySystem {

    // MARK: - Properties

    /// Reference to game coordinator
    private weak var coordinator: GameCoordinator?

    /// Parent entity for enemies
    private weak var parentEntity: Entity?

    /// All active enemy entities
    private var enemies: [Entity] = []

    /// Enemies pending respawn with their timers
    private var respawnQueue: [(position: SIMD3<Float>, timer: Float, config: EnemyConfig, movement: MovementConfig)] = []

    /// Destruction effect pool
    private var destructionEffects: [Entity] = []
    private var activeEffects: [(entity: Entity, timer: Float)] = []
    private let maxEffects = 10

    /// Attack timers for enemies that can attack
    private var attackTimers: [Entity: Float] = [:]

    /// Muzzle flash effect pool for enemy attacks
    private var enemyMuzzleFlashes: [Entity] = []
    private var activeFlashes: [(entity: Entity, timer: Float)] = []

    /// Movement data for mobile enemies
    private var movementData: [Entity: EnemyMovementData] = [:]

    /// Objective position enemies seek toward
    private var objectivePosition: SIMD3<Float> = SIMD3<Float>(0, 0, 5)

    struct EnemyMovementData {
        var config: MovementConfig
        var targetPosition: SIMD3<Float>
        var wanderTimer: Float
        var state: AIState

        enum AIState {
            case wandering
            case seeking
        }
    }

    // MARK: - Enemy Configuration

    struct EnemyConfig {
        let health: Int
        let size: Float
        let color: UIColor
        let scoreValue: Int
        let respawnDelay: Float
        /// If > 0, this enemy attacks the player
        let attackDamage: Int
        /// Seconds between attacks
        let attackInterval: Float

        static let basicTarget = EnemyConfig(
            health: 30,
            size: 1.0,
            color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0),
            scoreValue: 100,
            respawnDelay: 3.0,
            attackDamage: 0,
            attackInterval: 0
        )

        static let armoredTarget = EnemyConfig(
            health: 80,
            size: 1.2,
            color: UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0),
            scoreValue: 250,
            respawnDelay: 5.0,
            attackDamage: 0,
            attackInterval: 0
        )

        /// Turret enemy that attacks the player
        static let turret = EnemyConfig(
            health: 50,
            size: 0.8,
            color: UIColor(red: 0.7, green: 0.3, blue: 0.1, alpha: 1.0),
            scoreValue: 200,
            respawnDelay: 8.0,
            attackDamage: 5,
            attackInterval: 4.0
        )

        /// Infantry enemy that moves toward objective
        static let infantry = EnemyConfig(
            health: 15,
            size: 0.5,
            color: UIColor(red: 0.3, green: 0.5, blue: 0.2, alpha: 1.0),
            scoreValue: 50,
            respawnDelay: 2.0,
            attackDamage: 0,
            attackInterval: 0
        )

        /// Drone enemy - fast, fragile, erratic flight, attacks player
        static let drone = EnemyConfig(
            health: 10,
            size: 0.4,
            color: UIColor(red: 0.2, green: 0.8, blue: 0.9, alpha: 1.0),
            scoreValue: 75,
            respawnDelay: 6.0,
            attackDamage: 4,
            attackInterval: 5.0
        )
    }

    // MARK: - Movement Configuration

    struct MovementConfig {
        let speed: Float
        let wanderRadius: Float
        let seekSpeed: Float
        let isFlying: Bool
        let erraticFactor: Float // 0 = straight, 1 = very erratic

        static let none = MovementConfig(speed: 0, wanderRadius: 0, seekSpeed: 0, isFlying: false, erraticFactor: 0)
        static let infantry = MovementConfig(speed: 2.0, wanderRadius: 3.0, seekSpeed: 3.0, isFlying: false, erraticFactor: 0)
        static let drone = MovementConfig(speed: 6.0, wanderRadius: 8.0, seekSpeed: 4.0, isFlying: true, erraticFactor: 0.7)
    }

    // MARK: - Initialization

    init() {}

    func setup(parent: Entity, coordinator: GameCoordinator) {
        self.parentEntity = parent
        self.coordinator = coordinator

        // Create effect pools
        createDestructionEffectPool(parent: parent)
        createMuzzleFlashPool(parent: parent)

        // Spawn initial test targets
        spawnEnemy(at: SIMD3<Float>(0, 0.5, -8), config: .basicTarget, movement: .none)
        spawnEnemy(at: SIMD3<Float>(4, 0.6, -12), config: .armoredTarget, movement: .none)

        // Spawn turrets that attack the player
        spawnEnemy(at: SIMD3<Float>(-6, 0.4, -10), config: .turret, movement: .none)
        spawnEnemy(at: SIMD3<Float>(6, 0.4, -8), config: .turret, movement: .none)

        // Spawn infantry that move toward objective
        spawnEnemy(at: SIMD3<Float>(-4, 0.25, -15), config: .infantry, movement: .infantry)
        spawnEnemy(at: SIMD3<Float>(0, 0.25, -18), config: .infantry, movement: .infantry)
        spawnEnemy(at: SIMD3<Float>(4, 0.25, -16), config: .infantry, movement: .infantry)
        spawnEnemy(at: SIMD3<Float>(-2, 0.25, -20), config: .infantry, movement: .infantry)

        // Spawn drones - flying enemies with erratic movement
        spawnEnemy(at: SIMD3<Float>(-8, 3.0, -12), config: .drone, movement: .drone)
        spawnEnemy(at: SIMD3<Float>(8, 4.0, -10), config: .drone, movement: .drone)
        spawnEnemy(at: SIMD3<Float>(0, 3.5, -22), config: .drone, movement: .drone)
    }

    // MARK: - Enemy Creation

    private func createDestructionEffectPool(parent: Entity) {
        let mesh = MeshResource.generateSphere(radius: 0.3)
        var material = UnlitMaterial()
        material.color = .init(tint: UIColor(red: 1.0, green: 0.6, blue: 0.1, alpha: 1.0))

        for i in 0..<maxEffects {
            let effect = Entity()
            effect.name = "DestructionEffect_\(i)"
            effect.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])
            effect.isEnabled = false
            parent.addChild(effect)
            destructionEffects.append(effect)
        }
    }

    private func createMuzzleFlashPool(parent: Entity) {
        let mesh = MeshResource.generateSphere(radius: 0.15)
        var material = UnlitMaterial()
        material.color = .init(tint: UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0))

        for i in 0..<8 {
            let flash = Entity()
            flash.name = "EnemyMuzzleFlash_\(i)"
            flash.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])
            flash.isEnabled = false
            parent.addChild(flash)
            enemyMuzzleFlashes.append(flash)
        }
    }

    func spawnEnemy(at position: SIMD3<Float>, config: EnemyConfig, movement: MovementConfig = .none) {
        guard let parent = parentEntity else { return }

        let enemy = Entity()
        enemy.name = "Enemy_\(enemies.count)"
        enemy.position = position

        // Create mesh based on enemy type
        let mesh: MeshResource
        if movement.isFlying {
            // Drones get a disc/saucer shape
            mesh = MeshResource.generateCylinder(height: config.size * 0.3, radius: config.size * 0.6)
        } else if movement.speed > 0 {
            // Infantry gets taller, thinner shape
            mesh = MeshResource.generateBox(width: config.size * 0.6, height: config.size * 1.5, depth: config.size * 0.6)
        } else {
            mesh = MeshResource.generateBox(size: config.size)
        }
        var material = SimpleMaterial()
        material.color = .init(tint: config.color)
        material.roughness = 0.4
        material.metallic = 0.3
        enemy.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])

        // Add collision
        let shape = ShapeResource.generateBox(size: [config.size, config.size, config.size])
        enemy.components[CollisionComponent.self] = CollisionComponent(
            shapes: [shape],
            filter: CollisionGroups.enemyFilter
        )

        // Add health component
        enemy.components[HealthComponent.self] = HealthComponent(
            max: config.health,
            team: .enemy,
            scoreValue: config.scoreValue
        )

        // Store config for respawn
        enemy.components[EnemyConfigComponent.self] = EnemyConfigComponent(config: config, movement: movement)

        parent.addChild(enemy)
        enemies.append(enemy)

        // Initialize attack timer if this enemy can attack
        if config.attackDamage > 0 {
            // Start with full timer + 2 sec grace period so player has time to react
            attackTimers[enemy] = config.attackInterval + 2.0
        }

        // Initialize movement data if this enemy moves
        if movement.speed > 0 {
            let initialTarget: SIMD3<Float>
            let initialState: EnemyMovementData.AIState

            if movement.isFlying {
                // Drones start wandering
                initialTarget = SIMD3<Float>(
                    Float.random(in: -10.0...10.0),
                    Float.random(in: 2.0...5.0),
                    Float.random(in: -20.0 ... -5.0)
                )
                initialState = .wandering
            } else {
                // Ground units go straight for objective
                initialTarget = objectivePosition
                initialState = .seeking
            }

            movementData[enemy] = EnemyMovementData(
                config: movement,
                targetPosition: initialTarget,
                wanderTimer: Float.random(in: 1...3),
                state: initialState
            )
        }
    }

    // MARK: - Damage Detection

    /// Checks for projectile hits and applies damage
    /// Returns entities that were destroyed
    func checkProjectileHits(projectilePosition: SIMD3<Float>, damage: Int, splashRadius: Float) -> [Entity] {
        var destroyed: [Entity] = []

        for enemy in enemies {
            guard enemy.isEnabled else { continue }
            guard var health = enemy.components[HealthComponent.self] else { continue }
            guard !health.isDead else { continue }

            // Simple distance check for hit detection
            let distance = simd_distance(projectilePosition, enemy.position)
            let hitRadius = splashRadius > 0 ? splashRadius : 0.8 // Default hit radius

            if distance <= hitRadius {
                // Apply damage
                let killed = health.applyDamage(damage)
                enemy.components[HealthComponent.self] = health

                if killed {
                    destroyed.append(enemy)
                } else {
                    // Flash effect on hit (scale pulse)
                    pulseEnemy(enemy)
                }
            }
        }

        return destroyed
    }

    /// Applies damage to a specific enemy by entity
    func applyDamage(to enemy: Entity, amount: Int) -> Bool {
        guard var health = enemy.components[HealthComponent.self] else { return false }
        let killed = health.applyDamage(amount)
        enemy.components[HealthComponent.self] = health
        return killed
    }

    // MARK: - Destruction

    func destroyEnemy(_ enemy: Entity) {
        guard let health = enemy.components[HealthComponent.self],
              let config = enemy.components[EnemyConfigComponent.self] else { return }

        // Award score
        coordinator?.addScore(health.scoreValue)
        coordinator?.recordKill()

        // Show destruction effect
        showDestructionEffect(at: enemy.position)

        // Queue respawn with movement config
        respawnQueue.append((
            position: enemy.position,
            timer: config.config.respawnDelay,
            config: config.config,
            movement: config.movement
        ))

        // Clean up movement data
        movementData.removeValue(forKey: enemy)
        attackTimers.removeValue(forKey: enemy)

        // Disable enemy
        enemy.isEnabled = false
    }

    private func showDestructionEffect(at position: SIMD3<Float>) {
        // Find available effect
        guard let effect = destructionEffects.first(where: { !$0.isEnabled }) else { return }

        effect.position = position
        effect.scale = SIMD3<Float>(repeating: 0.5)
        effect.isEnabled = true

        activeEffects.append((entity: effect, timer: 0))
    }

    private func pulseEnemy(_ enemy: Entity) {
        // Simple scale pulse for hit feedback
        let originalScale = enemy.scale
        enemy.scale = originalScale * 1.2

        // Reset after short delay (handled in update)
        // For now, we just set it back immediately in next frame
    }

    // MARK: - Update

    func update(deltaTime: Float) {
        // Update destruction effects
        updateDestructionEffects(deltaTime: deltaTime)

        // Update muzzle flash effects
        updateMuzzleFlashes(deltaTime: deltaTime)

        // Update respawn timers
        updateRespawns(deltaTime: deltaTime)

        // Update enemy attacks
        updateEnemyAttacks(deltaTime: deltaTime)

        // Update enemy movement (infantry)
        updateEnemyMovement(deltaTime: deltaTime)

        // Reset any pulsed enemies
        for enemy in enemies where enemy.isEnabled {
            if enemy.scale.x > 1.0 {
                enemy.scale = simd_mix(enemy.scale, SIMD3<Float>(repeating: 1.0), SIMD3<Float>(repeating: 0.2))
                if enemy.scale.x < 1.01 {
                    enemy.scale = SIMD3<Float>(repeating: 1.0)
                }
            }
        }
    }

    private func updateDestructionEffects(deltaTime: Float) {
        for i in (0..<activeEffects.count).reversed() {
            activeEffects[i].timer += deltaTime
            let progress = activeEffects[i].timer / 0.5 // 0.5 second duration

            if progress >= 1.0 {
                // Effect complete
                activeEffects[i].entity.isEnabled = false
                activeEffects.remove(at: i)
            } else {
                // Animate effect (expand and fade)
                let scale = 0.5 + progress * 2.0
                activeEffects[i].entity.scale = SIMD3<Float>(repeating: scale)

                // Fade out via material (if we had opacity support)
                // For now just scale up
            }
        }
    }

    private func updateRespawns(deltaTime: Float) {
        for i in (0..<respawnQueue.count).reversed() {
            respawnQueue[i].timer -= deltaTime

            if respawnQueue[i].timer <= 0 {
                // Respawn the enemy
                let spawn = respawnQueue.remove(at: i)

                // Find a disabled enemy to reuse or spawn new
                if let reusable = enemies.first(where: { !$0.isEnabled }) {
                    // Reset and reuse
                    reusable.position = spawn.position
                    reusable.scale = SIMD3<Float>(repeating: 1.0)
                    reusable.isEnabled = true

                    // Reset health
                    reusable.components[HealthComponent.self] = HealthComponent(
                        max: spawn.config.health,
                        team: .enemy,
                        scoreValue: spawn.config.scoreValue
                    )

                    // Reset config component
                    reusable.components[EnemyConfigComponent.self] = EnemyConfigComponent(
                        config: spawn.config,
                        movement: spawn.movement
                    )

                    // Reset attack timer
                    if spawn.config.attackDamage > 0 {
                        attackTimers[reusable] = spawn.config.attackInterval
                    }

                    // Reset movement data
                    if spawn.movement.speed > 0 {
                        movementData[reusable] = EnemyMovementData(
                            config: spawn.movement,
                            targetPosition: objectivePosition,
                            wanderTimer: Float.random(in: 0...2),
                            state: .seeking
                        )
                    }
                } else {
                    // Spawn new
                    spawnEnemy(at: spawn.position, config: spawn.config, movement: spawn.movement)
                }
            }
        }
    }

    private func updateEnemyAttacks(deltaTime: Float) {
        for enemy in enemies where enemy.isEnabled {
            guard let config = enemy.components[EnemyConfigComponent.self],
                  config.config.attackDamage > 0 else { continue }

            // Update attack timer
            if var timer = attackTimers[enemy] {
                timer -= deltaTime
                if timer <= 0 {
                    // Fire at player!
                    performEnemyAttack(from: enemy, damage: config.config.attackDamage)
                    timer = config.config.attackInterval
                }
                attackTimers[enemy] = timer
            }
        }
    }

    private func performEnemyAttack(from enemy: Entity, damage: Int) {
        // Show muzzle flash
        showMuzzleFlash(at: enemy.position + SIMD3<Float>(0, 0.3, 0))

        // Play attack sound
        coordinator?.audioSystem?.play(.autocannonFire)

        // Apply damage to player
        coordinator?.applyDamage(damage)
    }

    private func showMuzzleFlash(at position: SIMD3<Float>) {
        guard let flash = enemyMuzzleFlashes.first(where: { !$0.isEnabled }) else { return }

        flash.position = position
        flash.scale = SIMD3<Float>(repeating: 1.0)
        flash.isEnabled = true

        activeFlashes.append((entity: flash, timer: 0))
    }

    private func updateMuzzleFlashes(deltaTime: Float) {
        for i in (0..<activeFlashes.count).reversed() {
            activeFlashes[i].timer += deltaTime
            let progress = activeFlashes[i].timer / 0.1 // 0.1 second duration

            if progress >= 1.0 {
                activeFlashes[i].entity.isEnabled = false
                activeFlashes.remove(at: i)
            } else {
                // Scale down effect
                let scale = 1.0 - progress
                activeFlashes[i].entity.scale = SIMD3<Float>(repeating: Float(scale))
            }
        }
    }

    private func updateEnemyMovement(deltaTime: Float) {
        for enemy in enemies where enemy.isEnabled {
            guard var data = movementData[enemy] else { continue }
            guard data.config.speed > 0 else { continue }

            // Flying enemies hover at their Y position
            let maintainHeight = data.config.isFlying

            switch data.state {
            case .wandering:
                // Move toward wander target
                let toTarget = data.targetPosition - enemy.position
                let distance = simd_length(toTarget)

                if distance > 0.5 {
                    var direction = simd_normalize(toTarget)

                    // Add erratic movement for drones
                    if data.config.erraticFactor > 0 {
                        let noise = SIMD3<Float>(
                            Float.random(in: -1...1),
                            Float.random(in: -0.5...0.5),
                            Float.random(in: -1...1)
                        ) * data.config.erraticFactor
                        direction = simd_normalize(direction + noise)
                    }

                    let movement = direction * data.config.speed * deltaTime

                    if maintainHeight {
                        enemy.position += movement
                    } else {
                        enemy.position += SIMD3<Float>(movement.x, 0, movement.z)
                    }

                    // Face movement direction
                    let angle = atan2(direction.x, direction.z)
                    enemy.orientation = simd_quatf(angle: angle, axis: [0, 1, 0])
                } else {
                    // Reached wander target, pick new one or switch to seeking
                    data.wanderTimer -= deltaTime
                    if data.wanderTimer <= 0 {
                        if data.config.isFlying {
                            // Drones pick new random wander point
                            data.targetPosition = SIMD3<Float>(
                                Float.random(in: -10.0...10.0),
                                Float.random(in: 2.0...5.0),
                                Float.random(in: -20.0 ... -5.0)
                            )
                            data.wanderTimer = Float.random(in: 1.0...3.0)
                        } else {
                            data.state = .seeking
                            data.targetPosition = objectivePosition
                        }
                    }
                }

            case .seeking:
                // Move toward objective
                let toObjective = objectivePosition - enemy.position
                let distance = simd_length(toObjective)

                if distance > 1.0 {
                    var direction = simd_normalize(toObjective)

                    // Add erratic movement for drones
                    if data.config.erraticFactor > 0 {
                        let noise = SIMD3<Float>(
                            Float.random(in: -1...1),
                            Float.random(in: -0.3...0.3),
                            Float.random(in: -1...1)
                        ) * data.config.erraticFactor * 0.5 // Less erratic when seeking
                        direction = simd_normalize(direction + noise)
                    }

                    let speed = data.config.seekSpeed > 0 ? data.config.seekSpeed : data.config.speed
                    let movement = direction * speed * deltaTime

                    if maintainHeight {
                        enemy.position += movement
                    } else {
                        enemy.position += SIMD3<Float>(movement.x, 0, movement.z)
                    }

                    // Face movement direction
                    let angle = atan2(direction.x, direction.z)
                    enemy.orientation = simd_quatf(angle: angle, axis: [0, 1, 0])
                } else {
                    // Reached objective - deal damage and destroy self
                    coordinator?.applyDamage(data.config.isFlying ? 8 : 5)
                    destroyEnemy(enemy)
                }
            }

            movementData[enemy] = data
        }
    }

    // MARK: - Queries

    /// Returns all active (alive) enemies
    var activeEnemies: [Entity] {
        enemies.filter { $0.isEnabled }
    }

    /// Returns enemy count for debug display
    var enemyCount: Int {
        enemies.filter { $0.isEnabled }.count
    }

    /// Finds the nearest enemy to a position
    func nearestEnemy(to position: SIMD3<Float>) -> Entity? {
        var nearest: Entity?
        var nearestDistance: Float = .infinity

        for enemy in enemies where enemy.isEnabled {
            let distance = simd_distance(position, enemy.position)
            if distance < nearestDistance {
                nearestDistance = distance
                nearest = enemy
            }
        }

        return nearest
    }
}

// MARK: - Enemy Config Component

/// Stores enemy configuration for respawning
struct EnemyConfigComponent: Component {
    let config: EnemySystem.EnemyConfig
    var movement: EnemySystem.MovementConfig = .none
}
