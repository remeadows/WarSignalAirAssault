import RealityKit
import UIKit

/// Manages a pool of reusable projectile entities to avoid allocation overhead
/// MANDATORY per CLAUDE.md: "Projectile pooling is MANDATORY"
///
/// Usage:
/// ```swift
/// let pool = ProjectilePool(capacity: 50, parent: gameRoot)
/// let projectile = pool.acquire()
/// projectile.position = firePosition
/// // ... later when projectile hits or expires:
/// pool.release(projectile)
/// ```
@MainActor
final class ProjectilePool {

    // MARK: - Configuration

    /// Pool settings per weapon type
    struct Config {
        let capacity: Int
        let meshRadius: Float
        let meshLength: Float
        let color: UIColor
        let emissiveIntensity: Float

        static let autocannon = Config(
            capacity: 60,
            meshRadius: 0.03,
            meshLength: 0.4,
            color: UIColor(red: 1.0, green: 0.9, blue: 0.3, alpha: 1.0),
            emissiveIntensity: 2.0
        )

        static let rockets = Config(
            capacity: 15,
            meshRadius: 0.1,
            meshLength: 0.6,
            color: UIColor(red: 1.0, green: 0.4, blue: 0.1, alpha: 1.0),
            emissiveIntensity: 3.0
        )

        static let heavyGun = Config(
            capacity: 30,
            meshRadius: 0.05,
            meshLength: 0.5,
            color: UIColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0),
            emissiveIntensity: 2.5
        )
    }

    // MARK: - Properties

    /// Parent entity to attach projectiles to
    private weak var parentEntity: Entity?

    /// All projectile entities in the pool
    private var allProjectiles: [Entity] = []

    /// Available (inactive) projectiles
    private var availableProjectiles: [Entity] = []

    /// Active projectiles with their data
    private var activeProjectiles: [Entity: ProjectileData] = [:]

    /// Pool configuration
    private let config: Config

    /// Shared mesh resource for all projectiles in this pool
    private let sharedMesh: MeshResource

    /// Shared material for all projectiles
    private let sharedMaterial: UnlitMaterial

    // MARK: - Projectile Data

    /// Runtime data for an active projectile
    struct ProjectileData {
        var velocity: SIMD3<Float>
        var damage: Int
        var splashRadius: Float
        var lifetime: Float
        var maxLifetime: Float
        var weaponType: WeaponType

        var isExpired: Bool { lifetime >= maxLifetime }
    }

    // MARK: - Initialization

    init(config: Config, parent: Entity) {
        self.config = config
        self.parentEntity = parent

        // Create shared mesh (cylinder for tracer effect - RealityKit has no capsule)
        self.sharedMesh = MeshResource.generateCylinder(
            height: config.meshLength,
            radius: config.meshRadius
        )

        // Create emissive material for tracer glow
        var material = UnlitMaterial()
        material.color = .init(tint: config.color)
        self.sharedMaterial = material

        // Pre-allocate all projectiles
        for i in 0..<config.capacity {
            let projectile = createProjectileEntity(index: i)
            allProjectiles.append(projectile)
            availableProjectiles.append(projectile)
            parent.addChild(projectile)
        }
    }

    // MARK: - Entity Creation

    private func createProjectileEntity(index: Int) -> Entity {
        let entity = Entity()
        entity.name = "Projectile_\(index)"

        // Add mesh component
        entity.components[ModelComponent.self] = ModelComponent(
            mesh: sharedMesh,
            materials: [sharedMaterial]
        )

        // Rotate so capsule points forward (along negative Z)
        entity.orientation = simd_quatf(angle: .pi / 2, axis: [1, 0, 0])

        // Add collision component (use box for simpler collision)
        let shape = ShapeResource.generateBox(
            width: config.meshRadius * 2,
            height: config.meshLength,
            depth: config.meshRadius * 2
        )
        entity.components[CollisionComponent.self] = CollisionComponent(
            shapes: [shape],
            filter: CollisionGroups.playerProjectileFilter
        )

        // Start disabled
        entity.isEnabled = false

        return entity
    }

    // MARK: - Pool Operations

    /// Acquires a projectile from the pool
    /// Returns nil if pool is exhausted
    func acquire(
        position: SIMD3<Float>,
        direction: SIMD3<Float>,
        weapon: WeaponType
    ) -> Entity? {
        guard !availableProjectiles.isEmpty else {
            // Pool exhausted - could expand dynamically or just skip
            return nil
        }

        let projectile = availableProjectiles.removeLast()

        // Configure projectile
        projectile.position = position
        projectile.isEnabled = true

        // Orient to face direction
        if simd_length(direction) > 0.001 {
            let normalizedDir = simd_normalize(direction)
            // Look rotation to face the direction
            projectile.look(at: position + normalizedDir, from: position, relativeTo: nil)
            // Additional rotation for cylinder orientation (align with travel direction)
            projectile.orientation *= simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
        }

        // Store projectile data
        let data = ProjectileData(
            velocity: simd_normalize(direction) * weapon.projectileSpeed,
            damage: weapon.damage,
            splashRadius: weapon.splashRadius,
            lifetime: 0,
            maxLifetime: 3.0, // 3 seconds max
            weaponType: weapon
        )
        activeProjectiles[projectile] = data

        return projectile
    }

    /// Releases a projectile back to the pool
    func release(_ projectile: Entity) {
        guard activeProjectiles.removeValue(forKey: projectile) != nil else {
            return // Not an active projectile from this pool
        }

        projectile.isEnabled = false
        projectile.position = SIMD3<Float>(0, -100, 0) // Move offscreen
        availableProjectiles.append(projectile)
    }

    /// Updates all active projectiles, returns projectiles that should be released
    /// - Parameter deltaTime: Time since last update
    /// - Parameter enemyPositions: Optional array of enemy positions for hit detection
    func update(deltaTime: Float, enemyPositions: [(position: SIMD3<Float>, radius: Float)] = []) -> [(entity: Entity, data: ProjectileData, hitPosition: SIMD3<Float>?)] {
        var toRelease: [(entity: Entity, data: ProjectileData, hitPosition: SIMD3<Float>?)] = []

        for (projectile, var data) in activeProjectiles {
            // Update position
            let movement = data.velocity * deltaTime
            projectile.position += movement

            // Update lifetime
            data.lifetime += deltaTime
            activeProjectiles[projectile] = data

            // Check expiration
            if data.isExpired {
                toRelease.append((projectile, data, nil))
                continue
            }

            // Check if below ground (simple ground collision)
            if projectile.position.y < 0 {
                toRelease.append((projectile, data, projectile.position))
                continue
            }

            // Check for enemy hits during flight
            for enemy in enemyPositions {
                let distance = simd_distance(projectile.position, enemy.position)
                if distance <= enemy.radius {
                    toRelease.append((projectile, data, projectile.position))
                    break
                }
            }
        }

        return toRelease
    }

    /// Releases all active projectiles
    func releaseAll() {
        for (projectile, _) in activeProjectiles {
            projectile.isEnabled = false
            projectile.position = SIMD3<Float>(0, -100, 0)
            availableProjectiles.append(projectile)
        }
        activeProjectiles.removeAll()
    }

    // MARK: - Stats

    var activeCount: Int { activeProjectiles.count }
    var availableCount: Int { availableProjectiles.count }
    var totalCount: Int { allProjectiles.count }
}
