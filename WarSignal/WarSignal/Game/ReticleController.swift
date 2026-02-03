import RealityKit
import UIKit
import simd

/// Controls the targeting reticle that follows touch input on the ground plane
@MainActor
final class ReticleController {

    // MARK: - Reticle Entity

    /// The main reticle entity
    private(set) var reticleEntity: Entity

    /// Inner ring for pulsing effect
    private var innerRing: Entity

    /// Outer ring
    private var outerRing: Entity

    /// Center dot
    private var centerDot: Entity

    // MARK: - State

    /// Current world position of reticle
    private(set) var worldPosition: SIMD3<Float> = .zero

    /// Whether reticle is currently visible
    var isVisible: Bool = false {
        didSet {
            reticleEntity.isEnabled = isVisible
        }
    }

    /// Whether currently over a valid target
    var hasValidTarget: Bool = false {
        didSet {
            updateTargetHighlight()
        }
    }

    // MARK: - Animation State

    private var pulsePhase: Float = 0
    private var rotationAngle: Float = 0

    // MARK: - Configuration

    /// Reticle size
    let reticleSize: Float = 1.5

    /// Colors
    let normalColor = UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 0.8) // Cyan
    let targetColor = UIColor(red: 1.0, green: 0.3, blue: 0.2, alpha: 0.9) // Red

    // MARK: - Initialization

    init() {
        // Create main container
        reticleEntity = Entity()
        reticleEntity.name = "Reticle"

        // Create outer ring
        outerRing = Self.createRing(radius: reticleSize * 0.5, thickness: 0.03, color: normalColor)
        outerRing.name = "OuterRing"
        reticleEntity.addChild(outerRing)

        // Create inner ring
        innerRing = Self.createRing(radius: reticleSize * 0.25, thickness: 0.02, color: normalColor)
        innerRing.name = "InnerRing"
        reticleEntity.addChild(innerRing)

        // Create center dot
        centerDot = Self.createDot(radius: 0.08, color: normalColor)
        centerDot.name = "CenterDot"
        reticleEntity.addChild(centerDot)

        // Create crosshair lines
        let crosshairs = Self.createCrosshairs(length: reticleSize * 0.3, thickness: 0.02, color: normalColor)
        for (index, line) in crosshairs.enumerated() {
            line.name = "Crosshair\(index)"
            reticleEntity.addChild(line)
        }

        // Position slightly above ground to avoid z-fighting
        reticleEntity.position.y = 0.05

        // Start hidden
        reticleEntity.isEnabled = false
    }

    // MARK: - Entity Creation

    /// Creates a ring using a torus-like shape (approximated with cylinder)
    private static func createRing(radius: Float, thickness: Float, color: UIColor) -> Entity {
        let entity = Entity()

        // Use a thin cylinder rotated to lie flat
        let mesh = MeshResource.generateCylinder(height: thickness, radius: radius)

        var material = UnlitMaterial()
        material.color = .init(tint: color)

        entity.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])

        // Rotate to lie flat on ground (cylinder is vertical by default)
        // No rotation needed - cylinder height becomes the ring thickness

        return entity
    }

    /// Creates a dot/sphere
    private static func createDot(radius: Float, color: UIColor) -> Entity {
        let entity = Entity()

        let mesh = MeshResource.generateSphere(radius: radius)

        var material = UnlitMaterial()
        material.color = .init(tint: color)

        entity.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])

        return entity
    }

    /// Creates crosshair lines
    private static func createCrosshairs(length: Float, thickness: Float, color: UIColor) -> [Entity] {
        var lines: [Entity] = []

        // Create 4 lines pointing outward from center
        let offsets: [SIMD3<Float>] = [
            [length * 0.7, 0, 0],   // Right
            [-length * 0.7, 0, 0],  // Left
            [0, 0, length * 0.7],   // Forward
            [0, 0, -length * 0.7]   // Back
        ]

        for i in 0..<4 {
            let line = Entity()
            let mesh = MeshResource.generateBox(size: [length * 0.4, thickness, thickness])

            var material = UnlitMaterial()
            material.color = .init(tint: color)

            line.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])
            line.position = offsets[i]

            if i >= 2 {
                // Rotate Z-axis lines
                line.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
            }

            lines.append(line)
        }

        return lines
    }

    // MARK: - Position Updates

    /// Sets reticle position in world coordinates
    func setPosition(_ position: SIMD3<Float>) {
        worldPosition = position
        reticleEntity.position = SIMD3<Float>(position.x, 0.05, position.z)
    }

    /// Shows the reticle
    func show() {
        isVisible = true
    }

    /// Hides the reticle
    func hide() {
        isVisible = false
    }

    // MARK: - Animation Updates

    /// Called every frame to update animations
    func update(deltaTime: Float) {
        guard isVisible else { return }

        // Pulse animation
        pulsePhase += deltaTime * 4.0
        let pulseScale = 1.0 + sin(pulsePhase) * 0.1
        innerRing.scale = SIMD3<Float>(repeating: Float(pulseScale))

        // Rotation animation for outer ring
        rotationAngle += deltaTime * 0.5
        outerRing.orientation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])
    }

    // MARK: - Target Highlighting

    private func updateTargetHighlight() {
        let color = hasValidTarget ? targetColor : normalColor

        // Update all child materials
        updateEntityColor(outerRing, color: color)
        updateEntityColor(innerRing, color: color)
        updateEntityColor(centerDot, color: color)

        // Update crosshairs
        for child in reticleEntity.children where child.name.starts(with: "Crosshair") {
            updateEntityColor(child, color: color)
        }
    }

    private func updateEntityColor(_ entity: Entity, color: UIColor) {
        if var model = entity.components[ModelComponent.self] {
            var material = UnlitMaterial()
            material.color = .init(tint: color)
            model.materials = [material]
            entity.components[ModelComponent.self] = model
        }
    }

    // MARK: - Scene Integration

    /// Adds reticle to scene content
    func addToScene(_ parent: Entity) {
        parent.addChild(reticleEntity)
    }
}
