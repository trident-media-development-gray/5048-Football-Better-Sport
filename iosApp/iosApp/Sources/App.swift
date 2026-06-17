import SwiftUI

@main
struct SelecaoApp: App {
    private let env = AppEnvironment.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(env)
                .environmentObject(env.localization)
                .environmentObject(env.fanStore)
        }
    }
}
