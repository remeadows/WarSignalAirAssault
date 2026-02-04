import RealityKit
import UIKit
import simd

/// Controls the targeting reticle that follows touch input on the ground plane
/// Designed to match Goliath's military AC-130 style crosshair
///
/// Military-accurate design based on real AC-130 targeting systems:
/// - Thin precise lines (not chunky)
/// - Corner brackets frame the kill zone
/// - Cardinal compass markers (N/E/S/W)
/// - Center crosshair with mil-dot style gap
@MainActor
final class ReticleController {

    // MARK: - Reticle Entity

    /// The main reticle entity
    private(set) var reticleEntity: Entity

    /// Corner brackets (4 corners)
    private var cornerBrackets: [Entity] = []

    /// Center crosshair lines
    private var crosshairLines: [Entity] = []

    /// Center dot
    private var centerDot: Entity

    /// Compass markers (N, E, S, W)
    private var compassMarkers: [Entity] = []

    /// Outer ring for target acquisition
    private var outerRing: Entity?

    // MARK: - State

    /// Current world position of reticle
    private(set) var worldPosition: SIMD3<Float> = .zero

    /// Whether reticle is currently visible (ALWAYS ON in gameplay)
    var isVisible: Bool = true {
        didSet {
            reticleEntity.isEnabled = isVisible
        }
    }

    /// Whether the player is actively aiming (touch down)
    var isAiming: Bool = false

    /// Whether currently over a valid target
    var hasValidTarget: Bool = false {
        didSet {
            updateTargetHighlight()
        }
    }

    // MARK: - Animation State

    private var pulsePhase: Float = 0
    private var rotationAngle: Float = 0

    // MARK: - Configuration (Military-Accurate Proportions)

    /// Overall reticle size - slightly smaller for precision feel
    let reticleSize: Float = 2.5

    /// Line thickness - THIN like real military optics
    let lineThickness: Float = 0.04

    /// Height above ground
    let reticleHeight: Float = 0.25

    /// Colors - Military green/white when not targeting, red when locked
    let normalColor = UIColor(red: 0.7, green: 1.0, blue: 0.7, alpha: 0.9) // Military green-white
    let aimingColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0) // Bright green when aiming
    let targetColor = UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 1.0) // Bright Red for targets

    // MARK: - Initialization

    init() {
        // Create main container
        reticleEntity = Entity()
        reticleEntity.name = "Reticle"

        // Create center dot first (needed for initialization) - smaller for precision
        centerDot = Self.createCenterDot(radius: 0.06, color: normalColor)
        centerDot.name = "CenterDot"
        reticleEntity.addChild(centerDot)

        // Create the military AC-130 style crosshair elements
        createOuterRing()
        createCornerBrackets()
        createCrosshairLines()
        createCompassMarkers()

        // Position above ground
        reticleEntity.position.y = reticleHeight

        // ALWAYS VISIBLE during gameplay (WS-023)
        reticleEntity.isEnabled = true
    }

    // MARK: - Outer Ring (Goliath-style target acquisition circle)

    /// Creates a thin outer ring like Goliath's targeting reticle
    private func createOuterRing() {
        let ring = Entity()
        ring.name = "OuterRing"

        // Create ring using multiple thin segments (RealityKit doesn't have torus)
        let segments = 32
        let ringRadius: Float = reticleSize * 0.5
        let segmentThickness = lineThickness * 0.8

        for i in 0..<segments {
            let angle1 = Float(i) / Float(segments) * 2 * .pi
            let angle2 = Float(i + 1) / Float(segments) * 2 * .pi

            let x1 = cos(angle1) * ringRadius
            let z1 = sin(angle1) * ringRadius
            let x2 = cos(angle2) * ringRadius
            let z2 = sin(angle2) * ringRadius

            // Calculate segment center and length
            let centerX = (x1 + x2) / 2
            let centerZ = (z1 + z2) / 2
            let length = sqrt(pow(x2 - x1, 2) + pow(z2 - z1, 2))

            let segment = Entity()
            segment.components[ModelComponent.self] = ModelComponent(
                mesh: MeshResource.generateBox(size: [length, 0.015, segmentThickness]),
                materials: [UnlitMaterial(color: normalColor)]
            )
            segment.position = [centerX, 0, centerZ]
            segment.orientation = simd_quatf(angle: angle1 + .pi / 2, axis: [0, 1, 0])
            ring.addChild(segment)
        }

        reticleEntity.addChild(ring)
        outerRing = ring
    }

    // MARK: - Goliath-Style Reticle Creation

    /// Creates the 4 corner brackets like Goliath's targeting reticle
    /// Military-accurate: thin lines at exact 45-degree corners
    private func createCornerBrackets() {
        let bracketLength: Float = reticleSize * 0.18  // Shorter, more precise
        let bracketOffset: Float = reticleSize * 0.35  // Tighter to center
        let thickness = lineThickness

        // Corner positions and rotations (top-left, top-right, bottom-right, bottom-left)
        let corners: [(position: SIMD3<Float>, rotationY: Float)] = [
            ([-bracketOffset, 0, -bracketOffset], 0),           // Top-left
            ([bracketOffset, 0, -bracketOffset], .pi / 2),      // Top-right
            ([bracketOffset, 0, bracketOffset], .pi),           // Bottom-right
            ([-bracketOffset, 0, bracketOffset], -.pi / 2)      // Bottom-left
        ]

        for (index, corner) in corners.enumerated() {
            let bracket = Self.createCornerBracket(
                length: bracketLength,
                thickness: thickness,
                color: normalColor
            )
            bracket.name = "Corner\(index)"
            bracket.position = corner.position
            bracket.orientation = simd_quatf(angle: corner.rotationY, axis: [0, 1, 0])
            reticleEntity.addChild(bracket)
            cornerBrackets.append(bracket)
        }
    }

    /// Creates the center crosshair lines (4 lines pointing to center with gap)
    /// Military-accurate: longer lines with precise gap for target acquisition
    private func createCrosshairLines() {
        let lineLength: Float = reticleSize * 0.22  // Longer for better visibility
        let gapFromCenter: Float = reticleSize * 0.05  // Tighter gap for precision
        let thickness = lineThickness * 0.6  // Thinner lines

        // Create 4 lines pointing inward (N, E, S, W)
        let directions: [(offset: SIMD3<Float>, size: SIMD3<Float>)] = [
            // North (toward camera, -Z)
            ([0, 0, -(gapFromCenter + lineLength/2)], [thickness, 0.015, lineLength]),
            // South (away from camera, +Z)
            ([0, 0, (gapFromCenter + lineLength/2)], [thickness, 0.015, lineLength]),
            // East (+X)
            ([(gapFromCenter + lineLength/2), 0, 0], [lineLength, 0.015, thickness]),
            // West (-X)
            ([-(gapFromCenter + lineLength/2), 0, 0], [lineLength, 0.015, thickness])
        ]

        for (index, dir) in directions.enumerated() {
            let line = Entity()
            line.name = "CrosshairLine\(index)"
            line.components[ModelComponent.self] = ModelComponent(
                mesh: MeshResource.generateBox(size: dir.size),
                materials: [UnlitMaterial(color: normalColor)]
            )
            line.position = dir.offset
            reticleEntity.addChild(line)
            crosshairLines.append(line)
        }
    }

    /// Creates compass direction markers (N, E, S, W) like Goliath
    /// Military-accurate: small triangular pointers at cardinal directions
    private func createCompassMarkers() {
        let markerOffset: Float = reticleSize * 0.58  // Just outside the ring
        let markerSize: Float = 0.08  // Smaller, more precise

        // Compass positions - small diamond markers
        let positions: [(pos: SIMD3<Float>, label: String, rotation: Float)] = [
            ([0, 0, -markerOffset], "N", 0),           // North - pointing up
            ([markerOffset, 0, 0], "E", .pi / 2),     // East - pointing right
            ([0, 0, markerOffset], "S", .pi),         // South - pointing down
            ([-markerOffset, 0, 0], "W", -.pi / 2)   // West - pointing left
        ]

        for marker in positions {
            // Create a small diamond as compass indicator
            let entity = Entity()
            entity.name = "Compass\(marker.label)"

            // Small rotated box as diamond marker
            let mesh = MeshResource.generateBox(size: [markerSize, 0.012, markerSize])
            entity.components[ModelComponent.self] = ModelComponent(
                mesh: mesh,
                materials: [UnlitMaterial(color: normalColor)]
            )
            entity.position = marker.pos
            entity.orientation = simd_quatf(angle: .pi / 4, axis: [0, 1, 0]) // Rotate 45° to make diamond

            reticleEntity.addChild(entity)
            compassMarkers.append(entity)
        }
    }

    // MARK: - Entity Creation Helpers

    /// Creates an L-shaped corner bracket
    private static func createCornerBracket(length: Float, thickness: Float, color: UIColor) -> Entity {
        let bracket = Entity()

        // Horizontal part of L
        let horizontal = Entity()
        horizontal.components[ModelComponent.self] = ModelComponent(
            mesh: MeshResource.generateBox(size: [length, 0.02, thickness]),
            materials: [UnlitMaterial(color: color)]
        )
        horizontal.position = [length / 2, 0, 0]
        bracket.addChild(horizontal)

        // Vertical part of L (in Z direction for top-down view)
        let vertical = Entity()
        vertical.components[ModelComponent.self] = ModelComponent(
            mesh: MeshResource.generateBox(size: [thickness, 0.02, length]),
            materials: [UnlitMaterial(color: color)]
        )
        vertical.position = [0, 0, length / 2]
        bracket.addChild(vertical)

        return bracket
    }

    /// Creates a center dot
    private static func createCenterDot(radius: Float, color: UIColor) -> Entity {
        let entity = Entity()

        // Small flat cylinder for center dot
        let mesh = MeshResource.generateCylinder(height: 0.02, radius: radius)
        var material = UnlitMaterial()
        material.color = .init(tint: color)

        entity.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])
        entity.position.y = 0.01

        return entity
    }

    // MARK: - Position Updates

    /// Sets reticle position in world coordinates
    func setPosition(_ position: SIMD3<Float>) {
        worldPosition = position
        reticleEntity.position = SIMD3<Float>(position.x, reticleHeight, position.z)
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

        // Pulse animation for center dot - subtle military feel
        pulsePhase += deltaTime * 2.5  // Slower pulse
        let pulseScale = 1.0 + sin(pulsePhase) * 0.1  // Subtle
        centerDot.scale = SIMD3<Float>(repeating: Float(pulseScale))

        // Slow rotation of outer ring when not targeting (scanning effect)
        if !hasValidTarget {
            rotationAngle += deltaTime * 0.3  // Very slow rotation
            outerRing?.orientation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])
        }
    }

    /// Sets the aiming state (whether player is actively touching/aiming)
    func setAiming(_ aiming: Bool) {
        isAiming = aiming
        // Could brighten reticle when actively aiming
    }

    // MARK: - Target Highlighting

    private func updateTargetHighlight() {
        let color = hasValidTarget ? targetColor : normalColor

        // Update center dot
        updateEntityColor(centerDot, color: color)

        // Update outer ring
        if let ring = outerRing {
            for child in ring.children {
                updateEntityColor(child, color: color)
            }
        }

        // Update corner brackets
        for bracket in cornerBrackets {
            for child in bracket.children {
                updateEntityColor(child, color: color)
            }
        }

        // Update crosshair lines
        for line in crosshairLines {
            updateEntityColor(line, color: color)
        }

        // Update compass markers
        for marker in compassMarkers {
            updateEntityColor(marker, color: color)
        }
    }

    private func updateEntityColor(_ entity: Entity, color: UIColor) {
        if var model = entity.components[ModelComponent.self] {
            let material = UnlitMaterial(color: color)
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
