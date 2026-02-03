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
    private var respawnQueue: [(position: SIMD3<Float>, timer: Float, config: EnemyConfig)] = []

    /// Destruction effect pool
    private var destructionEffects: [Entity] = []
    private var activeEffects: [(entity: Entity, timer: Float)] = []
    private let maxEffects = 10

    // MARK: - Enemy Configuration

    struct EnemyConfig {
        let health: Int
        let size: Float
        let color: UIColor
        let scoreValue: Int
        let respawnDelay: Float

        static let basicTarget = EnemyConfig(
            health: 30,
            size: 1.0,
            color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0),
            scoreValue: 100,
            respawnDelay: 3.0
        )

        static let armoredTarget = EnemyConfig(
            health: 80,
            size: 1.2,
            color: UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0),
            scoreValue: 250,
            respawnDelay: 5.0
        )
    }

    // MARK: - Initialization

    init() {}

    func setup(parent: Entity, coordinator: GameCoordinator) {
        self.parentEntity = parent
        self.coordinator = coordinator

        // Create destruction effect pool
        createDestructionEffectPool(parent: parent)

        // Spawn initial test targets
        spawnEnemy(at: SIMD3<Float>(0, 0.5, -8), config: .basicTarget)
        spawnEnemy(at: SIMD3<Float>(4, 0.6, -12), config: .armoredTarget)
        spawnEnemy(at: SIMD3<Float>(-4, 0.5, -6), config: .basicTarget)
        spawnEnemy(at: SIMD3<Float>(0, 0.5, -15), config: .basicTarget)
        spawnEnemy(at: SIMD3<Float>(-6, 0.5, -10), config: .basicTarget)
        spawnEnemy(at: SIMD3<Float>(6, 0.5, -8), config: .armoredTarget)
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

    func spawnEnemy(at position: SIMD3<Float>, config: EnemyConfig) {
        guard let parent = parentEntity else { return }

        let enemy = Entity()
        enemy.name = "Enemy_\(enemies.count)"
        enemy.position = position

        // Create mesh
        let mesh = MeshResource.generateBox(size: config.size)
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
        enemy.components[EnemyConfigComponent.self] = EnemyConfigComponent(config: config)

        parent.addChild(enemy)
        enemies.append(enemy)
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

        // Queue respawn
        respawnQueue.append((
            position: enemy.position,
            timer: config.config.respawnDelay,
            config: config.config
        ))

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

        // Update respawn timers
        updateRespawns(deltaTime: deltaTime)

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
                } else {
                    // Spawn new
                    spawnEnemy(at: spawn.position, config: spawn.config)
                }
            }
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
}
