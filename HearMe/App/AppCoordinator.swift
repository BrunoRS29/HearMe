import UIKit
import SwiftUI

final class AppCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Por enquanto, vai direto para a Home
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
    }
}
