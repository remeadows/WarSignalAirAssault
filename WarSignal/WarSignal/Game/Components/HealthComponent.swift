import RealityKit

/// Component tracking health for damageable entities
/// Used by enemies, destructibles, and potentially the player ship
struct HealthComponent: Component {

    // MARK: - Properties

    /// Current health points
    var current: Int

    /// Maximum health points
    var max: Int

    /// Whether this entity is dead
    var isDead: Bool { current <= 0 }

    /// Health as a percentage (0.0 to 1.0)
    var percent: Float { Float(current) / Float(max) }

    /// Team affiliation for damage filtering
    var team: Team

    /// Score awarded when destroyed
    var scoreValue: Int

    // MARK: - Initialization

    init(max: Int, team: Team = .enemy, scoreValue: Int = 100) {
        self.current = max
        self.max = max
        self.team = team
        self.scoreValue = scoreValue
    }

    // MARK: - Damage

    /// Applies damage and returns true if this killed the entity
    mutating func applyDamage(_ amount: Int) -> Bool {
        guard !isDead else { return false }

        current = Swift.max(0, current - amount)
        return isDead
    }

    /// Heals the entity
    mutating func heal(_ amount: Int) {
        current = Swift.min(max, current + amount)
    }

    /// Resets health to max
    mutating func reset() {
        current = max
    }
}

// MARK: - Team

/// Team affiliation for entities
enum Team: Int {
    case player = 0
    case enemy = 1
    case neutral = 2

    /// Returns true if this team can be damaged by the other team
    func canBeDamagedBy(_ other: Team) -> Bool {
        switch (self, other) {
        case (.player, .enemy), (.enemy, .player):
            return true
        case (.neutral, _), (_, .neutral):
            return true
        default:
            return false
        }
    }
}
