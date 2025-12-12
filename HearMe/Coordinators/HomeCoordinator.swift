import UIKit
import SwiftUI

final class HomeCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = HomeViewModel()
        let view = HomeView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: false)
    }
}
