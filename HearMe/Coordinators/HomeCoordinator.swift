import SwiftUI

@MainActor
final class HomeCoordinator: Coordinator {
    typealias Body = HomeView
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    @ViewBuilder
    func start() -> HomeView {
        let viewModel = HomeViewModel(coordinator: self)
        HomeView(viewModel: viewModel)
    }

    func navigateToSoftd(with track: Music) {
        appCoordinator.showSoftd(with: track)
    }

    func logout() {
        appCoordinator.navigationPath.removeAll()
        appCoordinator.showLogin()
    }
    
    func navigateToProfile() {
        appCoordinator.navigationPath.removeAll()
        appCoordinator.showProfile()
    }
    
    func navigateToCalendar() {
        appCoordinator.navigationPath.removeAll()
        appCoordinator.showCalendar()
    }
}
