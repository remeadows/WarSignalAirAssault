import SwiftUI

/// Root navigation view for WarSignal
/// Handles flow between menu screens and gameplay
struct ContentView: View {
    @State private var gameState: GameState = .mainMenu
    @State private var coordinator = GameCoordinator()

    var body: some View {
        ZStack {
            // Dark cyberpunk background
            Color.black.ignoresSafeArea()

            switch gameState {
            case .mainMenu:
                MainMenuView(onStartGame: {
                    gameState = .playing
                })
                .transition(.opacity)

            case .playing:
                GameView(coordinator: coordinator) {
                    gameState = .mainMenu
                }
                .ignoresSafeArea()
                .transition(.opacity)

            case .paused:
                // TODO: Pause menu overlay
                GameView(coordinator: coordinator)
                    .ignoresSafeArea()

            case .missionComplete:
                // TODO: Mission results screen
                MainMenuView(onStartGame: {
                    gameState = .playing
                })
            }
        }
        .animation(.easeInOut(duration: 0.3), value: gameState)
    }
}

/// Game state machine
enum GameState {
    case mainMenu
    case playing
    case paused
    case missionComplete
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
