 import SwiftUI

@MainActor
final class SoftdCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func start() -> some View {
        let viewModel = SoftdViewModel(coordinator: self)
        return SoftdView(viewModel: viewModel)
    }
    
    func navigateToHome() {
        appCoordinator.showHome()
    }
}
