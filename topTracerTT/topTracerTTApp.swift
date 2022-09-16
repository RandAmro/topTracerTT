import SwiftUI

@main
struct topTracerTTApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel())
        }
    }
}
