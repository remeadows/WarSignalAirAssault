import SwiftUI

/// Main entry point for WarSignal
/// A cyberpunk gunship/overwatch action game
@main
struct WarSignalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Cyberpunk aesthetic
        }
    }
}
