import SwiftUI

@MainActor
final class HomeCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func start() -> some View {
        let viewModel = HomeViewModel(coordinator: self)
        return HomeView(viewModel: viewModel)
    }
    
    func logout() {
        appCoordinator.logout()
    }
}
