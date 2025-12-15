import SwiftUI
import UIKit


@MainActor
final class LoginCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func start() -> some View {
        let viewModel = LoginViewModel(coordinator: self)
        return LoginView(viewModel: viewModel)
    }
    
    func navigateToHome() {
        appCoordinator.showHome()
    }
}
