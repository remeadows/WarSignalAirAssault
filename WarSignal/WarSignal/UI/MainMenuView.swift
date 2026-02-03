import SwiftUI

/// Main menu screen with cyberpunk styling
/// Optimized for landscape orientation
struct MainMenuView: View {
    let onStartGame: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.height < 400
            let fontSize: CGFloat = isCompact ? 44 : 56

            VStack(spacing: isCompact ? 20 : 30) {
                Spacer()

                // Title section - centered
                VStack(spacing: isCompact ? 4 : 8) {
                    // Title - horizontal layout
                    HStack(spacing: 12) {
                        Text("WAR")
                            .font(.system(size: fontSize, weight: .black, design: .default))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cyan, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("SIGNAL")
                            .font(.system(size: fontSize, weight: .black, design: .default))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    .shadow(color: .cyan.opacity(0.5), radius: 20)

                    Text("OVERWATCH PROTOCOL")
                        .font(.system(size: isCompact ? 10 : 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(.gray)
                        .tracking(6)
                        .fixedSize(horizontal: true, vertical: false)
                }

                // Menu buttons - horizontal row for landscape
                HStack(spacing: 16) {
                    MenuButton(title: "START", icon: "play.fill", isCompact: isCompact) {
                        onStartGame()
                    }

                    MenuButton(title: "ARMORY", icon: "wrench.and.screwdriver.fill", isCompact: isCompact) {
                        // TODO: Weapon upgrades
                    }
                    .opacity(0.5)

                    MenuButton(title: "INTEL", icon: "doc.text.fill", isCompact: isCompact) {
                        // TODO: Lore/characters
                    }
                    .opacity(0.5)
                }

                Spacer()

                // Version info
                Text("v0.1.0 • Milestone 1")
                    .font(.caption2)
                    .foregroundStyle(.gray.opacity(0.5))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
    }
}

/// Cyberpunk styled menu button
struct MenuButton: View {
    let title: String
    let icon: String
    var isCompact: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.white)
                Text(title)
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.cyan.opacity(0.5), .purple.opacity(0.5)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainMenuView(onStartGame: {})
        .preferredColorScheme(.dark)
}
