import RealityKit
import simd

/// Controls the game camera for overhead gunship perspective
/// Provides smooth movement, zoom levels, and camera shake effects
@MainActor
final class CameraController {

    // MARK: - Camera Entity

    /// The camera entity in the scene
    private(set) var cameraEntity: Entity

    /// Anchor entity that camera is attached to (for easier transforms)
    private(set) var cameraAnchor: Entity

    // MARK: - Camera Settings

    /// Current zoom level (0 = closest, max = furthest)
    private(set) var currentZoomLevel: Int = 1

    /// Available zoom configurations
    struct ZoomLevel {
        let height: Float      // Y position
        let distance: Float    // Z offset (negative = behind target)
        let pitch: Float       // Rotation around X axis (degrees)
        let fov: Float         // Field of view (degrees)
    }

    /// Predefined zoom levels for gunship gameplay
    let zoomLevels: [ZoomLevel] = [
        // Close - tactical view
        ZoomLevel(height: 15, distance: -8, pitch: 55, fov: 60),
        // Medium - default gameplay (matches Zombie Gunship feel)
        ZoomLevel(height: 25, distance: -15, pitch: 50, fov: 55),
        // Far - strategic overview
        ZoomLevel(height: 40, distance: -25, pitch: 45, fov: 50)
    ]

    // MARK: - Smooth Movement

    /// Target position for smooth interpolation
    private var targetPosition: SIMD3<Float> = .zero

    /// Current interpolated position
    private var currentPosition: SIMD3<Float> = .zero

    /// Smoothing factor (0 = instant, 1 = very slow)
    var smoothingFactor: Float = 0.92

    // MARK: - Camera Shake

    /// Current shake intensity (0 = none)
    private var shakeIntensity: Float = 0

    /// Shake decay rate per second
    private var shakeDecay: Float = 5.0

    /// Shake frequency
    private var shakeTime: Float = 0

    // MARK: - Initialization

    init() {
        // Create anchor for camera positioning
        cameraAnchor = Entity()
        cameraAnchor.name = "CameraAnchor"

        // Create perspective camera
        cameraEntity = Entity()
        cameraEntity.name = "GameCamera"

        // Add perspective camera component
        let camera = PerspectiveCameraComponent(
            near: 0.1,
            far: 500,
            fieldOfViewInDegrees: 55
        )
        cameraEntity.components[PerspectiveCameraComponent.self] = camera

        // Attach camera to anchor
        cameraAnchor.addChild(cameraEntity)

        // Set initial position
        applyZoomLevel(zoomLevels[currentZoomLevel], animated: false)
    }

    // MARK: - Setup

    /// Adds camera to the RealityKit content
    func addToContent(_ content: RealityViewCameraContent) {
        content.add(cameraAnchor)
    }

    /// Adds camera anchor to an entity (alternative setup)
    func addToEntity(_ parent: Entity) {
        parent.addChild(cameraAnchor)
    }

    // MARK: - Zoom Control

    /// Cycles to next zoom level
    func cycleZoom() {
        currentZoomLevel = (currentZoomLevel + 1) % zoomLevels.count
        applyZoomLevel(zoomLevels[currentZoomLevel], animated: true)
    }

    /// Sets specific zoom level
    func setZoomLevel(_ level: Int) {
        guard level >= 0 && level < zoomLevels.count else { return }
        currentZoomLevel = level
        applyZoomLevel(zoomLevels[currentZoomLevel], animated: true)
    }

    /// Applies zoom configuration
    private func applyZoomLevel(_ zoom: ZoomLevel, animated: Bool) {
        let targetCameraPos = SIMD3<Float>(0, zoom.height, zoom.distance)

        if animated {
            // Will be interpolated in update()
            // For now, apply directly (smooth zoom can be added later)
            cameraEntity.position = targetCameraPos
        } else {
            cameraEntity.position = targetCameraPos
        }

        // Apply pitch rotation (looking down at the battlefield)
        let pitchRadians = zoom.pitch * .pi / 180
        cameraEntity.orientation = simd_quatf(angle: -pitchRadians, axis: [1, 0, 0])

        // Update FOV
        if var camera = cameraEntity.components[PerspectiveCameraComponent.self] {
            camera.fieldOfViewInDegrees = zoom.fov
            cameraEntity.components[PerspectiveCameraComponent.self] = camera
        }
    }

    // MARK: - Position Control

    /// Sets target position for camera to follow (world coordinates)
    func setTargetPosition(_ position: SIMD3<Float>) {
        targetPosition = SIMD3<Float>(position.x, 0, position.z)
    }

    /// Instantly moves camera to position
    func setPositionImmediate(_ position: SIMD3<Float>) {
        targetPosition = SIMD3<Float>(position.x, 0, position.z)
        currentPosition = targetPosition
        cameraAnchor.position = currentPosition
    }

    // MARK: - Camera Shake

    /// Triggers camera shake effect
    /// - Parameters:
    ///   - intensity: Shake strength (0.1 = subtle, 1.0 = heavy)
    ///   - duration: How long shake lasts (affects decay)
    func shake(intensity: Float, duration: Float = 0.3) {
        shakeIntensity = max(shakeIntensity, intensity)
        shakeDecay = intensity / duration
    }

    /// Shake presets for different weapon types
    func shakeForWeapon(_ weaponType: String) {
        switch weaponType {
        case "autocannon":
            shake(intensity: 0.05, duration: 0.1)
        case "rockets":
            shake(intensity: 0.3, duration: 0.4)
        case "heavyGun":
            shake(intensity: 0.15, duration: 0.2)
        case "emp":
            shake(intensity: 0.4, duration: 0.5)
        default:
            break
        }
    }

    // MARK: - Update

    /// Called every frame to update camera position and effects
    func update(deltaTime: Float) {
        // Smooth position interpolation
        currentPosition = mix(currentPosition, targetPosition, t: 1.0 - smoothingFactor)
        var finalPosition = currentPosition

        // Apply camera shake
        if shakeIntensity > 0.001 {
            shakeTime += deltaTime * 50 // Shake frequency
            let shakeOffset = SIMD3<Float>(
                sin(shakeTime * 1.1) * shakeIntensity,
                sin(shakeTime * 1.3) * shakeIntensity * 0.5,
                sin(shakeTime * 0.9) * shakeIntensity
            )
            finalPosition += shakeOffset

            // Decay shake
            shakeIntensity = max(0, shakeIntensity - shakeDecay * deltaTime)
        }

        // Apply position to anchor
        cameraAnchor.position = finalPosition
    }

    // MARK: - Utilities

    /// Gets the current camera world position
    var worldPosition: SIMD3<Float> {
        cameraAnchor.position + cameraEntity.position
    }

    /// Gets camera forward direction (for raycasting)
    var forwardDirection: SIMD3<Float> {
        let rotation = cameraEntity.orientation
        return rotation.act(SIMD3<Float>(0, 0, -1))
    }

    /// Gets current zoom level info
    var currentZoom: ZoomLevel {
        zoomLevels[currentZoomLevel]
    }
}

// MARK: - RealityViewCameraContent Protocol

/// Protocol to abstract RealityView content for camera setup
protocol RealityViewCameraContent {
    func add(_ entity: Entity)
}

// Extension to make RealityViewContent conform (if needed)
// Note: In actual use, we pass through the make closure's content parameter
