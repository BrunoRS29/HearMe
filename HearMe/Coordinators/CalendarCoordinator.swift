import SwiftUI
import UIKit

@MainActor
final class CalendarCoordinator: Coordinator {
    private let appCoordinator: AppCoordinator
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func start() -> some View {
        let viewModel = CalendarViewModel(coordinator: self)
        return CalendarView(viewModel: viewModel)
    }
    
    func navigateToHome() {
        appCoordinator.navigationPath.removeAll()
        appCoordinator.showHome()
    }
    
    func navigateToProfile() {
        appCoordinator.navigationPath.removeAll()
        appCoordinator.showProfile()
    }
}
