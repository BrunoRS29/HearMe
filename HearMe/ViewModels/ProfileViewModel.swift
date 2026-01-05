import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    
    
    private let coordinator: ProfileCoordinator
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    func goToHome() {
        coordinator.navigateToHome()
    }
    
    func goToCalendar() {
        coordinator.navigateToCalendar()
    }
}
