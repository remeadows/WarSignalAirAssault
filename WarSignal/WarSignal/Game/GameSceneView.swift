import SwiftUI
import RealityKit

/// UIViewController that hosts the ARView with proper full-screen support
class GameSceneViewController: UIViewController {
    var arView: ARView!
    var coordinator: GameCoordinator?
    var onSceneReady: (() -> Void)?
    var displayLink: CADisplayLink?
    var lastUpdateTime: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create ARView
        arView = ARView(frame: view.bounds, cameraMode: .nonAR, automaticallyConfigureSession: false)
        arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        arView.environment.background = .color(.black)

        // Add to view hierarchy
        view.addSubview(arView)

        // Setup scene
        setupScene()

        // Setup display link for updates
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ensure ARView always matches parent bounds
        arView.frame = view.bounds
    }

    override var prefersStatusBarHidden: Bool { true }
    override var prefersHomeIndicatorAutoHidden: Bool { true }

    private func setupScene() {
        guard let coordinator = coordinator else { return }

        // Create the game scene
        let anchor = AnchorEntity(world: .zero)

        // Create root entity for game objects
        let gameRoot = Entity()
        gameRoot.name = "GameRoot"
        anchor.addChild(gameRoot)
        coordinator.rootEntity = gameRoot

        // Create ground plane
        let floor = createFloor()
        anchor.addChild(floor)

        // Create lighting
        let light = createAmbientLight()
        anchor.addChild(light)

        let sunLight = createDirectionalLight()
        anchor.addChild(sunLight)

        // Setup enemy system (replaces old test targets)
        if let enemySystem = coordinator.enemySystem {
            enemySystem.setup(parent: gameRoot, coordinator: coordinator)
        }

        // Add reticle
        if let reticleController = coordinator.reticleController {
            reticleController.addToScene(gameRoot)
        }

        // Setup weapon system
        if let weaponSystem = coordinator.weaponSystem {
            weaponSystem.setup(parent: gameRoot, coordinator: coordinator)
        }

        // Add anchor to scene
        arView.scene.addAnchor(anchor)

        // Setup camera
        setupCamera()

        // Signal scene is ready
        DispatchQueue.main.async { [weak self] in
            self?.onSceneReady?()
        }
    }

    private func setupCamera() {
        let cameraEntity = PerspectiveCamera()
        cameraEntity.camera.fieldOfViewInDegrees = 55

        let cameraAnchor = AnchorEntity(world: .zero)
        cameraAnchor.addChild(cameraEntity)

        cameraEntity.position = [0, 25, 15]
        cameraEntity.look(at: [0, 0, -8], from: cameraEntity.position, relativeTo: nil)

        arView.scene.addAnchor(cameraAnchor)
    }

    @objc func update() {
        guard let coordinator = coordinator else { return }

        let now = Date()
        let deltaTime = now.timeIntervalSince(lastUpdateTime)
        lastUpdateTime = now

        coordinator.update(deltaTime: deltaTime)
        coordinator.updateCamera(deltaTime: Float(deltaTime))
        coordinator.updateReticle(deltaTime: Float(deltaTime))

        // Sync weapon system camera position
        if let cameraController = coordinator.cameraController {
            coordinator.weaponSystem?.cameraPosition = cameraController.worldPosition
        }

        if deltaTime > 0 {
            coordinator.fps = 1.0 / deltaTime
        }
    }

    // MARK: - Scene Creation

    private func createFloor() -> Entity {
        let floor = Entity()
        floor.name = "Floor"

        let mesh = MeshResource.generatePlane(width: 100, depth: 100)

        var material = SimpleMaterial()
        material.color = .init(tint: .init(red: 0.05, green: 0.05, blue: 0.08, alpha: 1.0))
        material.roughness = 0.9

        floor.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])
        floor.position = [0, 0, 0]

        let shape = ShapeResource.generateBox(width: 100, height: 0.01, depth: 100)
        floor.components[CollisionComponent.self] = CollisionComponent(shapes: [shape])

        return floor
    }

    private func createAmbientLight() -> Entity {
        let light = Entity()
        light.name = "AmbientLight"

        light.components[PointLightComponent.self] = PointLightComponent(
            color: .init(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0),
            intensity: 5000,
            attenuationRadius: 100
        )

        light.position = [0, 30, 0]
        return light
    }

    private func createDirectionalLight() -> Entity {
        let light = Entity()
        light.name = "DirectionalLight"

        light.components[DirectionalLightComponent.self] = DirectionalLightComponent(
            color: .init(red: 1.0, green: 0.95, blue: 0.9, alpha: 1.0),
            intensity: 3000,
            isRealWorldProxy: false
        )

        light.position = [10, 20, 10]
        light.look(at: [0, 0, 0], from: light.position, relativeTo: nil)

        return light
    }

    deinit {
        displayLink?.invalidate()
    }
}

/// SwiftUI wrapper for the game scene view controller
struct GameSceneView: UIViewControllerRepresentable {
    @Bindable var coordinator: GameCoordinator
    let onSceneReady: () -> Void

    func makeUIViewController(context: Context) -> GameSceneViewController {
        let vc = GameSceneViewController()
        vc.coordinator = coordinator
        vc.onSceneReady = onSceneReady
        return vc
    }

    func updateUIViewController(_ uiViewController: GameSceneViewController, context: Context) {
        // Updates handled by display link
    }
}
