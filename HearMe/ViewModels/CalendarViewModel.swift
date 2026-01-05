import Foundation
import Combine

@MainActor
final class CalendarViewModel: ObservableObject {
    
    private let coordinator: CalendarCoordinator
    
    init(coordinator: CalendarCoordinator) {
        self.coordinator = coordinator
    }
    
    func goToHome() {
        coordinator.navigateToHome()
    }
    
    func goToProfile() {
        coordinator.navigateToProfile()
    }
    
    
}
