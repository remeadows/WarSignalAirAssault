# Skills.md — WarSignal Development Patterns

## SwiftUI Patterns (iOS 26+)

### State Management

```swift
// GameCoordinator - the UI ↔ Game bridge
@Observable
@MainActor
final class GameCoordinator {
    var playerHealth: Int = 100
    var shieldHealth: Int = 50
    var currentWeapon: WeaponType = .autocannon
    var aimPosition: SIMD3<Float> = .zero
    var isFiring: Bool = false

    func startMission() { }
    func pauseGame() { }
    func fire(at position: SIMD3<Float>) { }
}

// In SwiftUI View
@State private var coordinator = GameCoordinator()
```

### Modern API Requirements

| Deprecated | Use Instead |
|------------|-------------|
| `foregroundColor()` | `foregroundStyle()` |
| `cornerRadius()` | `clipShape(.rect(cornerRadius:))` |
| `NavigationView` | `NavigationStack` |
| `onTapGesture()` | `Button` (for tappable elements) |
| `@StateObject` | `@State` with `@Observable` |

### Liquid Glass (iOS 26+ Cyberpunk UI)

```swift
// Glass effect with fallback
if #available(iOS 26, *) {
    content
        .padding()
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
} else {
    content
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
}

// Glass buttons
Button("FIRE") { coordinator.fire(at: aimPosition) }
    .buttonStyle(.glassProminent)
```

---

## RealityKit Patterns

### Entity Setup with Components

```swift
import RealityKit

func createEnemy(at position: SIMD3<Float>) -> Entity {
    let entity = Entity()
    entity.name = "Enemy_Infantry"

    // Transform
    entity.position = position

    // Visual (placeholder)
    let mesh = MeshResource.generateBox(size: 0.5)
    let material = SimpleMaterial(color: .red, isMetallic: false)
    entity.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])

    // Physics
    entity.components[PhysicsBodyComponent.self] = PhysicsBodyComponent(
        massProperties: .default,
        mode: .dynamic
    )

    // Collision
    let shape = ShapeResource.generateBox(size: [0.5, 0.5, 0.5])
    entity.components[CollisionComponent.self] = CollisionComponent(
        shapes: [shape],
        filter: .init(group: CollisionGroups.enemy, mask: CollisionGroups.projectile)
    )

    return entity
}
```

### RealityView Integration

```swift
import SwiftUI
import RealityKit

struct GameView: View {
    @State private var coordinator: GameCoordinator

    var body: some View {
        RealityView { content in
            // Initial setup
            let floor = createFloor()
            content.add(floor)

            let camera = createCamera()
            content.add(camera)

        } update: { content in
            // Per-frame updates
            // Update reticle position
            // Process weapon firing
            // Update enemy AI
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    // Convert to world position via raycast
                    coordinator.updateAimPosition(screenPoint: value.location)
                }
        )
    }
}
```

### Collision Groups

```swift
// CollisionGroups.swift
import RealityKit

struct CollisionGroups {
    static let player     = CollisionGroup(rawValue: 1 << 0)
    static let enemy      = CollisionGroup(rawValue: 1 << 1)
    static let projectile = CollisionGroup(rawValue: 1 << 2)
    static let terrain    = CollisionGroup(rawValue: 1 << 3)
    static let pickup     = CollisionGroup(rawValue: 1 << 4)
    static let shield     = CollisionGroup(rawValue: 1 << 5)

    // Common masks
    static let projectileHits: CollisionGroup = [.enemy, .terrain]
    static let enemyHits: CollisionGroup = [.player, .shield, .terrain]
}
```

### Screen-to-World Raycast

```swift
func worldPosition(from screenPoint: CGPoint, in arView: ARView) -> SIMD3<Float>? {
    let ray = arView.ray(through: screenPoint)

    let results = arView.scene.raycast(
        origin: ray?.origin ?? .zero,
        direction: ray?.direction ?? [0, -1, 0],
        length: 100,
        query: .nearest,
        mask: CollisionGroups.terrain
    )

    return results.first?.position
}
```

---

## Audio Patterns (AVAudioEngine)

### AudioManager Structure

```swift
import AVFoundation

final class AudioManager {
    static let shared = AudioManager()

    private let engine = AVAudioEngine()
    private var sfxPlayers: [AVAudioPlayerNode] = []
    private var sfxBuffers: [String: AVAudioPCMBuffer] = [:]

    // Volume categories
    var sfxVolume: Float = 1.0
    var musicVolume: Float = 0.7
    var ambientVolume: Float = 0.5

    func preload(_ sounds: [String]) {
        for name in sounds {
            guard let url = Bundle.main.url(forResource: name, withExtension: "wav"),
                  let file = try? AVAudioFile(forReading: url),
                  let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat,
                                                 frameCapacity: AVAudioFrameCount(file.length)) else {
                continue
            }
            try? file.read(into: buffer)
            sfxBuffers[name] = buffer
        }
    }

    func playSFX(_ name: String) {
        guard let buffer = sfxBuffers[name] else { return }
        // Get available player from pool and play
    }
}
```

### Sound Categories

```swift
enum SoundCategory {
    case gunfire    // autocannon, rockets
    case explosion  // impacts, destruction
    case ambient    // city hum, wind
    case music      // background tracks
    case ui         // buttons, alerts
}
```

---

## Object Pooling

### Generic Pool

```swift
final class ObjectPool<T> {
    private var available: [T] = []
    private var inUse: [T] = []
    private let factory: () -> T

    init(initialSize: Int, factory: @escaping () -> T) {
        self.factory = factory
        for _ in 0..<initialSize {
            available.append(factory())
        }
    }

    func acquire() -> T {
        if available.isEmpty {
            available.append(factory())
        }
        let item = available.removeLast()
        inUse.append(item)
        return item
    }

    func release(_ item: T) {
        if let index = inUse.firstIndex(where: { $0 as AnyObject === item as AnyObject }) {
            inUse.remove(at: index)
            available.append(item)
        }
    }
}
```

### Projectile Pooling (Mandatory)

```swift
// Pre-create 50 projectile entities
let projectilePool = ObjectPool<Entity>(initialSize: 50) {
    createProjectileEntity()
}

// On fire
let projectile = projectilePool.acquire()
projectile.isEnabled = true
projectile.position = muzzlePosition
// ... set velocity

// On hit or timeout
projectile.isEnabled = false
projectilePool.release(projectile)
```

---

## Performance Rules

1. **Projectile pooling is MANDATORY** — never create/destroy per-shot
2. **Limit active particles** — max 100 simultaneous
3. **Track entity counts** — debug overlay showing active entities
4. **Profile with Instruments** — especially RealityKit frame time
5. **Prefer transforms over mesh changes** — scale/rotate/translate is cheaper
6. **Batch similar entities** — group enemies by type for update efficiency

---

## Touch Input

```swift
// Landscape-optimized touch zones
struct TouchZones {
    static let aimArea = CGRect(x: 0, y: 0, width: 0.7, height: 1.0)  // Left 70%
    static let weaponSelect = CGRect(x: 0.7, y: 0, width: 0.3, height: 0.5)  // Right top
    static let fireButton = CGRect(x: 0.7, y: 0.5, width: 0.3, height: 0.5)  // Right bottom
}

// DragGesture for continuous aiming
DragGesture(minimumDistance: 0)
    .onChanged { value in
        coordinator.aimPosition = worldPosition(from: value.location)
    }

// LongPressGesture for hold-to-fire
LongPressGesture(minimumDuration: 0.1)
    .onChanged { _ in coordinator.startFiring() }
    .onEnded { _ in coordinator.stopFiring() }
```
