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

            // HUD Overlay with Fire Button (on top)
            HUDOverlay(coordinator: coordinator, onClose: onClose)
        }
        .ignoresSafeArea(.all)
        .contentShape(Rectangle()) // Make entire area respond to gestures
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    coordinator.updateAimScreenPosition(value.location)
                    let worldPos = screenToWorld(value.location)
                    coordinator.updateAimPosition(worldPos)
                    // Reticle is ALWAYS visible now (WS-023)
                    // Just start firing on touch
                    coordinator.startFiring()
                }
                .onEnded { _ in
                    // Reticle stays visible, just stop firing
                    coordinator.stopFiring()
                }
        )
        .onAppear {
            // Initialize reticle at center of play area
            let centerPos = screenToWorld(CGPoint(x: 466, y: 215)) // Center of landscape screen
            coordinator.updateAimPosition(centerPos)
        }
    }

    // MARK: - Input Conversion

    /// Converts screen coordinates to world position on ground plane
    func screenToWorld(_ screenPos: CGPoint) -> SIMD3<Float> {
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

// MARK: - Touch Aiming Layer

/// Transparent layer that captures touch input for aiming
/// Placed on top but allows interactive HUD elements to receive taps first
struct TouchAimingLayer: View {
    @Bindable var coordinator: GameCoordinator
    let screenToWorld: (CGPoint) -> SIMD3<Float>

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            coordinator.updateAimScreenPosition(value.location)
                            let worldPos = screenToWorld(value.location)
                            coordinator.updateAimPosition(worldPos)
                            coordinator.showReticle()
                            coordinator.startFiring()
                        }
                        .onEnded { _ in
                            coordinator.hideReticle()
                            coordinator.stopFiring()
                        }
                )
        }
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

/// HUD overlay showing game state with cyberpunk liquid glass aesthetic
struct HUDOverlay: View {
    @Bindable var coordinator: GameCoordinator
    var onClose: (() -> Void)? = nil

    var body: some View {
        VStack {
            // Top HUD - Allow hit testing only on interactive elements
            HStack(alignment: .top) {
                // Left - Health & Shield (display only - pass touches through)
                VStack(alignment: .leading, spacing: 6) {
                    // Health bar
                    HUDBar(
                        icon: "heart.fill",
                        iconColor: .red,
                        value: Float(coordinator.playerHealth),
                        maxValue: Float(coordinator.playerMaxHealth),
                        barColor: .red,
                        label: "\(coordinator.playerHealth)",
                        isLow: coordinator.playerHealth < 30
                    )

                    // Shield bar
                    HUDBar(
                        icon: "shield.fill",
                        iconColor: .cyan,
                        value: Float(coordinator.shieldHealth),
                        maxValue: Float(coordinator.shieldMaxHealth),
                        barColor: .cyan,
                        label: "\(coordinator.shieldHealth)",
                        isLow: coordinator.shieldHealth == 0
                    )
                }
                .padding(10)
                .glassEffect()
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.cyan.opacity(0.4), .purple.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .allowsHitTesting(false)

                Spacer()

                // Center - Mission Timer (display only - pass touches through)
                VStack(spacing: 2) {
                    Text(formatTime(coordinator.missionTimeRemaining))
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundStyle(
                            coordinator.missionTimeRemaining < 30
                                ? .red
                                : .white
                        )
                        .shadow(color: coordinator.missionTimeRemaining < 30 ? .red.opacity(0.5) : .clear, radius: 4)

                    Text("MISSION TIME")
                        .font(.system(size: 8, weight: .medium, design: .monospaced))
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .glassEffect()
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                )
                .allowsHitTesting(false)

                Spacer()

                // Right - Score + Zoom + Close
                HStack(spacing: 8) {
                    // Score
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(coordinator.score)")
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        Text("SCORE")
                            .font(.system(size: 8, weight: .medium, design: .monospaced))
                            .foregroundStyle(.gray)
                    }

                    // MAGNIFICATION indicator (Goliath-style) + Zoom button
                    Button {
                        coordinator.cycleZoom()
                    } label: {
                        VStack(spacing: 1) {
                            Text("MAG")
                                .font(.system(size: 7, weight: .medium, design: .monospaced))
                                .foregroundStyle(.gray)
                            Text("\(magnificationValue)X")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundStyle(.green)
                        }
                        .frame(width: 40, height: 36)
                        .background(.black.opacity(0.4))
                        .clipShape(.rect(cornerRadius: 4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(.green.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .allowsHitTesting(true)

                    // Close button (interactive - enable hit testing)
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
                        .allowsHitTesting(true)
                    }
                }
                .padding(10)
                .glassEffect()
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.orange.opacity(0.3), .yellow.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            Spacer()

            // Bottom HUD
            HStack(alignment: .bottom) {
                // Left - Weapon info (display only - pass touches through)
                VStack(alignment: .leading, spacing: 6) {
                    // Current weapon
                    HStack(spacing: 8) {
                        Image(systemName: coordinator.currentWeapon.icon)
                            .font(.title2)
                            .foregroundStyle(coordinator.currentWeapon.hudColor)
                            .shadow(color: coordinator.currentWeapon.hudColor.opacity(0.5), radius: 4)
                        Text(coordinator.currentWeapon.shortName)
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .fixedSize(horizontal: true, vertical: false)
                    }

                    // Ammo
                    HStack(spacing: 4) {
                        Text("AMMO:")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(.gray)
                        Text(coordinator.currentWeapon == .autocannon ? "∞" : "\(coordinator.currentAmmo)")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundStyle(coordinator.currentAmmo < 5 && coordinator.currentWeapon != .autocannon ? .red : .white)
                    }
                }
                .padding(10)
                .glassEffect()
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(coordinator.currentWeapon.hudColor.opacity(0.4), lineWidth: 1)
                )
                .allowsHitTesting(false)

                Spacer()

                // Center - Weapon selector (interactive - enable hit testing)
                HStack(spacing: 6) {
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
                .glassEffect()
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                )
                .allowsHitTesting(true)

                Spacer()

                // Heat gauge (display only - pass touches through)
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        if coordinator.isOverheated {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(.red)
                        }
                        Text(coordinator.isOverheated ? "OVERHEATED!" : "HEAT")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(coordinator.isOverheated ? .red : .gray)
                    }

                    // Heat bar with glow effect
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.gray.opacity(0.3))
                            .frame(width: 80, height: 10)

                        // Heat fill
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: heatGradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 80 * CGFloat(coordinator.heatLevel), height: 10)
                            .shadow(color: heatColor.opacity(0.6), radius: coordinator.heatLevel > 0.7 ? 4 : 0)

                        // Threshold markers
                        HStack(spacing: 0) {
                            Spacer()
                                .frame(width: 56) // 70% mark
                            Rectangle()
                                .fill(.white.opacity(0.5))
                                .frame(width: 1, height: 10)
                            Spacer()
                        }
                        .frame(width: 80)
                    }
                }
                .padding(10)
                .glassEffect()
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            coordinator.isOverheated ? .red.opacity(0.6) : .orange.opacity(0.3),
                            lineWidth: 1
                        )
                )
                .allowsHitTesting(false)

                // Fire Button (interactive - enable hit testing)
                FireButton(coordinator: coordinator)
                    .allowsHitTesting(true)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .foregroundStyle(.white)
        // NOTE: Don't set allowsHitTesting(false) here - it would block ALL child touches
        // Instead, individual non-interactive elements have allowsHitTesting(false)

        // Damage flash overlay
        if coordinator.showDamageFlash {
            DamageFlashOverlay()
        }

        // Low health warning vignette
        if coordinator.playerHealth < 30 {
            LowHealthVignette(healthPercent: coordinator.healthPercent)
        }

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

    /// Magnification value based on zoom level (Goliath-style)
    private var magnificationValue: Int {
        switch coordinator.currentZoomLevel {
        case 0: return 10  // Close zoom = 10X
        case 1: return 5   // Medium zoom = 5X
        case 2: return 2   // Far zoom = 2X (wide view)
        default: return 5
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

    private var heatGradientColors: [Color] {
        if coordinator.isOverheated {
            return [.orange, .red]
        } else if coordinator.heatLevel > 0.7 {
            return [.yellow, .orange, .red]
        } else {
            return [.green, .yellow, .orange]
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
    var isLow: Bool = false

    private var fillPercent: CGFloat {
        guard maxValue > 0 else { return 0 }
        return CGFloat(value / maxValue)
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 20)
                .shadow(color: isLow ? iconColor.opacity(0.8) : .clear, radius: isLow ? 6 : 0)

            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gray.opacity(0.3))
                    .frame(width: 80, height: 12)

                // Fill with gradient
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [barColor.opacity(0.8), barColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 80 * fillPercent, height: 12)
                    .shadow(color: barColor.opacity(isLow ? 0.8 : 0.4), radius: isLow ? 4 : 2)

                // Segment markers
                HStack(spacing: 0) {
                    ForEach(1..<4, id: \.self) { i in
                        Spacer()
                            .frame(width: CGFloat(i) * 20 - 1)
                        Rectangle()
                            .fill(.black.opacity(0.3))
                            .frame(width: 1, height: 12)
                    }
                    Spacer()
                }
                .frame(width: 80)
            }

            Text(label)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .frame(width: 35, alignment: .trailing)
                .foregroundStyle(isLow ? .red : .white)
        }
    }
}

struct WeaponButton: View {
    let weapon: WeaponType
    let isSelected: Bool
    let ammo: Int
    let action: () -> Void

    private var isUnlimited: Bool {
        weapon == .autocannon
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: weapon.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(isSelected ? weapon.hudColor : .white)
                    .shadow(color: isSelected ? weapon.hudColor.opacity(0.6) : .clear, radius: 4)

                Text(isUnlimited ? "∞" : "\(ammo)")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(ammo == 0 && !isUnlimited ? .red : .white.opacity(0.8))
            }
            .frame(width: 48, height: 48)
            .background(
                isSelected
                    ? weapon.hudColor.opacity(0.25)
                    : .white.opacity(0.05)
            )
            .clipShape(.rect(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        isSelected
                            ? weapon.hudColor.opacity(0.8)
                            : .white.opacity(0.2),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(.plain)
        .opacity(ammo == 0 && !isUnlimited ? 0.4 : 1.0)
    }
}

/// Large fire button for weapon firing with cyberpunk styling
struct FireButton: View {
    @Bindable var coordinator: GameCoordinator

    private var buttonColor: Color {
        coordinator.currentWeapon.hudColor
    }

    var body: some View {
        Button {
            // Hold-to-fire is handled by simultaneousGesture below
        } label: {
            ZStack {
                // Outer glow ring (when firing)
                if coordinator.isFiring {
                    Circle()
                        .fill(buttonColor.opacity(0.3))
                        .frame(width: 85, height: 85)
                        .blur(radius: 8)
                }

                // Outer ring
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: coordinator.isFiring
                                ? [buttonColor, buttonColor.opacity(0.6)]
                                : [buttonColor.opacity(0.8), buttonColor.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: coordinator.isFiring ? 4 : 3
                    )
                    .frame(width: 72, height: 72)

                // Inner fill
                Circle()
                    .fill(
                        RadialGradient(
                            colors: coordinator.isFiring
                                ? [buttonColor, buttonColor.opacity(0.7)]
                                : [buttonColor.opacity(0.6), buttonColor.opacity(0.2)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 32
                        )
                    )
                    .frame(width: 62, height: 62)

                // Fire icon
                Image(systemName: coordinator.currentWeapon.icon)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: buttonColor.opacity(coordinator.isFiring ? 0.8 : 0.4), radius: coordinator.isFiring ? 6 : 2)

                // Overheated indicator
                if coordinator.isOverheated {
                    Circle()
                        .strokeBorder(.red, lineWidth: 2)
                        .frame(width: 78, height: 78)
                        .opacity(0.8)
                }
            }
            .scaleEffect(coordinator.isFiring ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: coordinator.isFiring)
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

// MARK: - Damage Feedback Views

/// Red flash overlay when player takes damage
struct DamageFlashOverlay: View {
    var body: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    colors: [.red.opacity(0.0), .red.opacity(0.4)],
                    center: .center,
                    startRadius: 100,
                    endRadius: 500
                )
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

/// Pulsing red vignette when health is critically low
struct LowHealthVignette: View {
    let healthPercent: Float
    @State private var pulsePhase: Double = 0

    private var vignetteOpacity: Double {
        let baseOpacity = Double(1.0 - healthPercent) * 0.4
        let pulse = sin(pulsePhase * 3) * 0.1 // Subtle pulse
        return baseOpacity + pulse
    }

    var body: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    colors: [.clear, .red.opacity(vignetteOpacity)],
                    center: .center,
                    startRadius: 150,
                    endRadius: 400
                )
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    pulsePhase = .pi * 2
                }
            }
    }
}

/// Shield break effect overlay
struct ShieldBreakOverlay: View {
    var body: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    colors: [.cyan.opacity(0.0), .cyan.opacity(0.3)],
                    center: .center,
                    startRadius: 100,
                    endRadius: 600
                )
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

#Preview {
    GameView(coordinator: GameCoordinator())
        .preferredColorScheme(.dark)
}
