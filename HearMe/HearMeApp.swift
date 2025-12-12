import SwiftUI

@main
struct HearMeApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
        }
    }
}
