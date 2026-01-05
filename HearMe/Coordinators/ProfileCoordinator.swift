import SwiftUI
import UIKit

@MainActor
final class ProfileCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func start() -> some View {
        let viewModel = ProfileViewModel(coordinator: self)
        return ProfileView(viewModel: viewModel)
    }
    
    func navigateToHome() {
        appCoordinator.navigationPath.removeAll()
        appCoordinator.showHome()
        print("chegueiaqui")
    }
    
    func navigateToCalendar() {
        appCoordinator.navigationPath.removeAll()
        appCoordinator.showCalendar()
    }
    
    
}
