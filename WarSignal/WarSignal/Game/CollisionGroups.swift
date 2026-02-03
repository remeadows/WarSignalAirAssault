import RealityKit

/// Collision groups for WarSignal entities
/// Used to filter which entities can collide with each other
///
/// Usage:
/// ```swift
/// entity.components[CollisionComponent.self] = CollisionComponent(
///     shapes: [shape],
///     filter: .init(
///         group: CollisionGroups.projectile,
///         mask: CollisionGroups.enemy
///     )
/// )
/// ```
struct CollisionGroups {

    // MARK: - Group Definitions

    /// Default group for non-interacting entities
    static let `default` = CollisionGroup(rawValue: 1 << 0)

    /// Player ship (for incoming enemy fire)
    static let player = CollisionGroup(rawValue: 1 << 1)

    /// Player projectiles (autocannon, rockets, etc.)
    static let playerProjectile = CollisionGroup(rawValue: 1 << 2)

    /// Enemy units (infantry, drones, turrets)
    static let enemy = CollisionGroup(rawValue: 1 << 3)

    /// Enemy projectiles (anti-air fire)
    static let enemyProjectile = CollisionGroup(rawValue: 1 << 4)

    /// Terrain/environment (ground, buildings, obstacles)
    static let terrain = CollisionGroup(rawValue: 1 << 5)

    /// Pickups/collectibles
    static let pickup = CollisionGroup(rawValue: 1 << 6)

    /// Explosion damage areas (for splash damage)
    static let explosionArea = CollisionGroup(rawValue: 1 << 7)

    // MARK: - Common Masks

    /// Player projectiles hit enemies and terrain
    static let playerProjectileMask: CollisionGroup = [enemy, terrain]

    /// Enemy projectiles hit player
    static let enemyProjectileMask: CollisionGroup = [player]

    /// Enemies can be hit by player projectiles and explosions
    static let enemyMask: CollisionGroup = [playerProjectile, explosionArea, terrain]

    /// Player can be hit by enemy projectiles
    static let playerMask: CollisionGroup = [enemyProjectile]

    /// Terrain blocks all projectiles
    static let terrainMask: CollisionGroup = [playerProjectile, enemyProjectile]

    /// Pickups only interact with player
    static let pickupMask: CollisionGroup = [player]

    /// Explosions hit enemies
    static let explosionMask: CollisionGroup = [enemy]

    // MARK: - Filter Presets

    /// Filter for player projectiles
    static var playerProjectileFilter: CollisionFilter {
        CollisionFilter(group: playerProjectile, mask: playerProjectileMask)
    }

    /// Filter for enemy projectiles
    static var enemyProjectileFilter: CollisionFilter {
        CollisionFilter(group: enemyProjectile, mask: enemyProjectileMask)
    }

    /// Filter for enemy units
    static var enemyFilter: CollisionFilter {
        CollisionFilter(group: enemy, mask: enemyMask)
    }

    /// Filter for player ship
    static var playerFilter: CollisionFilter {
        CollisionFilter(group: player, mask: playerMask)
    }

    /// Filter for terrain/obstacles
    static var terrainFilter: CollisionFilter {
        CollisionFilter(group: terrain, mask: terrainMask)
    }

    /// Filter for explosion areas
    static var explosionFilter: CollisionFilter {
        CollisionFilter(group: explosionArea, mask: explosionMask)
    }
}
