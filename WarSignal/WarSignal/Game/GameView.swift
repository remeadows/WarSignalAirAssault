import SwiftUI
import RealityKit

/// Main game view hosting RealityKit scene
/// Handles 3D rendering and touch input for aiming
struct GameView: View {
    @Bindable var coordinator: GameCoordinator
    var onClose: (() -> Void)? = nil

    var body: some View {
        ZStack {
            // 3D Game Scene using ARView (fills entire screen)
            GameSceneView(coordinator: coordinator) {
                coordinator.startMission()
            }
            .ignoresSafeArea(.all)

            // Touch input layer for aiming (transparent, on top of 3D scene)
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            coordinator.updateAimScreenPosition(value.location)
                            let worldPos = screenToWorld(value.location)
                            coordinator.updateAimPosition(worldPos)
                            coordinator.showReticle()
                        }
                        .onEnded { _ in
                            coordinator.hideReticle()
                        }
                )
                .ignoresSafeArea(.all)

            // HUD Overlay with Fire Button
            HUDOverlay(coordinator: coordinator, onClose: onClose)
        }
        .ignoresSafeArea(.all)
    }

    // MARK: - Input Conversion

    /// Converts screen coordinates to world position on ground plane
    private func screenToWorld(_ screenPos: CGPoint) -> SIMD3<Float> {
        // Use fixed landscape dimensions for iPhone 17 Pro Max
        // This avoids deprecated UIScreen.main
        let screenWidth: CGFloat = 932
        let screenHeight: CGFloat = 430

        // Normalize to -1...1 (center of screen = 0,0)
        let normalizedX = (screenPos.x / screenWidth) * 2 - 1
        let normalizedY = (screenPos.y / screenHeight) * 2 - 1

        // Get current zoom level for scale adjustment
        let zoomLevel = coordinator.currentZoomLevel

        // Scale factors based on zoom level
        let scaleFactors: [(x: Float, z: Float, offset: Float)] = [
            (10, 8, -8),    // Zoom 1 (close)
            (15, 12, -10),  // Zoom 2 (medium)
            (22, 18, -12)   // Zoom 3 (far)
        ]

        let scale = scaleFactors[min(zoomLevel, scaleFactors.count - 1)]

        // Map to world coordinates
        let worldX = Float(normalizedX) * scale.x
        let worldZ = Float(normalizedY) * scale.z + scale.offset

        return SIMD3<Float>(worldX, 0.05, worldZ)
    }
}

// MARK: - Target Colors

/// Colors for test targets
enum TargetColor {
    case red, orange, yellow, green, blue, purple

    var uiColor: UIColor {
        switch self {
        case .red: return UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
        case .orange: return UIColor(red: 0.9, green: 0.5, blue: 0.1, alpha: 1.0)
        case .yellow: return UIColor(red: 0.9, green: 0.8, blue: 0.1, alpha: 1.0)
        case .green: return UIColor(red: 0.1, green: 0.7, blue: 0.2, alpha: 1.0)
        case .blue: return UIColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0)
        case .purple: return UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0)
        }
    }
}

// MARK: - HUD Overlay

/// HUD overlay showing game state
struct HUDOverlay: View {
    @Bindable var coordinator: GameCoordinator
    var onClose: (() -> Void)? = nil

    var body: some View {
        VStack {
            // Top HUD
            HStack(alignment: .top) {
                // Left - Health & Shield
                VStack(alignment: .leading, spacing: 6) {
                    // Health bar
                    HUDBar(
                        icon: "heart.fill",
                        iconColor: .red,
                        value: Float(coordinator.playerHealth),
                        maxValue: Float(coordinator.playerMaxHealth),
                        barColor: .red,
                        label: "\(coordinator.playerHealth)"
                    )

                    // Shield bar
                    HUDBar(
                        icon: "shield.fill",
                        iconColor: .cyan,
                        value: Float(coordinator.shieldHealth),
                        maxValue: Float(coordinator.shieldMaxHealth),
                        barColor: .cyan,
                        label: "\(coordinator.shieldHealth)"
                    )
                }
                .padding(10)
                .background(.black.opacity(0.6))
                .clipShape(.rect(cornerRadius: 8))

                Spacer()

                // Center - Mission Timer
                VStack(spacing: 2) {
                    Text(formatTime(coordinator.missionTimeRemaining))
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundStyle(coordinator.missionTimeRemaining < 30 ? .red : .white)

                    Text("MISSION TIME")
                        .font(.system(size: 8, weight: .medium, design: .monospaced))
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.black.opacity(0.6))
                .clipShape(.rect(cornerRadius: 8))

                Spacer()

                // Right - Score + Zoom + Close
                HStack(spacing: 8) {
                    // Score
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(coordinator.score)")
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                        Text("SCORE")
                            .font(.system(size: 8, weight: .medium, design: .monospaced))
                            .foregroundStyle(.gray)
                    }

                    // Zoom button
                    Button {
                        coordinator.cycleZoom()
                    } label: {
                        VStack(spacing: 2) {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 14))
                            Text("×\(coordinator.currentZoomLevel + 1)")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                        }
                        .frame(width: 36, height: 36)
                        .background(.white.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(.cyan.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    // Close button
                    if let onClose = onClose {
                        Button {
                            onClose()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 36, height: 36)
                                .background(.white.opacity(0.1))
                                .clipShape(.rect(cornerRadius: 6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(10)
                .background(.black.opacity(0.6))
                .clipShape(.rect(cornerRadius: 8))
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            Spacer()

            // Bottom HUD
            HStack(alignment: .bottom) {
                // Left - Weapon info
                VStack(alignment: .leading, spacing: 6) {
                    // Current weapon
                    HStack(spacing: 8) {
                        Image(systemName: coordinator.currentWeapon.icon)
                            .font(.title2)
                        Text(coordinator.currentWeapon.shortName)
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .fixedSize(horizontal: true, vertical: false)
                    }

                    // Ammo
                    Text("AMMO: \(coordinator.currentAmmo)")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(coordinator.currentAmmo < 5 ? .red : .white)
                }
                .padding(10)
                .background(.black.opacity(0.6))
                .clipShape(.rect(cornerRadius: 8))

                Spacer()

                // Center - Weapon selector
                HStack(spacing: 8) {
                    ForEach(WeaponType.allCases) { weapon in
                        WeaponButton(
                            weapon: weapon,
                            isSelected: coordinator.currentWeapon == weapon,
                            ammo: coordinator.ammo[weapon] ?? 0
                        ) {
                            coordinator.selectWeapon(weapon)
                        }
                    }
                }
                .padding(8)
                .background(.black.opacity(0.6))
                .clipShape(.rect(cornerRadius: 8))

                Spacer()

                // Heat gauge
                VStack(alignment: .trailing, spacing: 4) {
                    Text(coordinator.isOverheated ? "OVERHEATED!" : "HEAT")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(coordinator.isOverheated ? .red : .gray)

                    // Heat bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.gray.opacity(0.3))

                            RoundedRectangle(cornerRadius: 3)
                                .fill(heatColor)
                                .frame(width: geo.size.width * CGFloat(coordinator.heatLevel))
                        }
                    }
                    .frame(width: 80, height: 8)
                }
                .padding(10)
                .background(.black.opacity(0.6))
                .clipShape(.rect(cornerRadius: 8))

                // Fire Button
                FireButton(coordinator: coordinator)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .foregroundStyle(.white)

        // Debug overlay
        if coordinator.showDebugOverlay {
            VStack(alignment: .leading, spacing: 2) {
                Text("FPS: \(Int(coordinator.fps))")
                Text("Entities: \(coordinator.entityCount)")
                Text("Projectiles: \(coordinator.activeProjectiles)")
                Text("Phase: \(String(describing: coordinator.gamePhase))")
            }
            .font(.system(size: 10, design: .monospaced))
            .foregroundStyle(.green)
            .padding(8)
            .background(.black.opacity(0.7))
            .clipShape(.rect(cornerRadius: 4))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(50)
        }
    }

    private var heatColor: Color {
        if coordinator.isOverheated {
            return .red
        } else if coordinator.heatLevel > 0.7 {
            return .orange
        } else {
            return .yellow
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - HUD Components

struct HUDBar: View {
    let icon: String
    let iconColor: Color
    let value: Float
    let maxValue: Float
    let barColor: Color
    let label: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 20)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(.gray.opacity(0.3))

                    RoundedRectangle(cornerRadius: 3)
                        .fill(barColor)
                        .frame(width: geo.size.width * CGFloat(value / maxValue))
                }
            }
            .frame(width: 80, height: 10)

            Text(label)
                .font(.system(size: 12, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
}

struct WeaponButton: View {
    let weapon: WeaponType
    let isSelected: Bool
    let ammo: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: weapon.icon)
                    .font(.system(size: 18))

                Text("\(ammo)")
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundStyle(ammo == 0 ? .red : .white.opacity(0.7))
            }
            .frame(width: 44, height: 44)
            .background(isSelected ? .cyan.opacity(0.3) : .clear)
            .clipShape(.rect(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(isSelected ? .cyan : .white.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .opacity(ammo == 0 ? 0.5 : 1.0)
    }
}

/// Large fire button for weapon firing
struct FireButton: View {
    @Bindable var coordinator: GameCoordinator

    var body: some View {
        Button {
            // Toggle firing on tap (for now, until we implement hold-to-fire)
        } label: {
            ZStack {
                // Outer ring
                Circle()
                    .strokeBorder(
                        coordinator.isFiring ? Color.orange : Color.red.opacity(0.8),
                        lineWidth: 3
                    )
                    .frame(width: 70, height: 70)

                // Inner fill
                Circle()
                    .fill(
                        RadialGradient(
                            colors: coordinator.isFiring
                                ? [.orange, .red]
                                : [.red.opacity(0.8), .red.opacity(0.4)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 35
                        )
                    )
                    .frame(width: 60, height: 60)

                // Fire icon
                Image(systemName: "flame.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
        .opacity(coordinator.canFire ? 1.0 : 0.5)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    coordinator.startFiring()
                }
                .onEnded { _ in
                    coordinator.stopFiring()
                }
        )
    }
}

#Preview {
    GameView(coordinator: GameCoordinator())
        .preferredColorScheme(.dark)
}
