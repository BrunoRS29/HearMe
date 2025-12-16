import Foundation
import Combine

@MainActor
final class SoftdViewModel: ObservableObject {
    
    private let coordinator: SoftdCoordinator
    
    init(coordinator: SoftdCoordinator) {
        self.coordinator = coordinator
    }
    
    
    func defineSongOfTheDay() {
        
    }
}
