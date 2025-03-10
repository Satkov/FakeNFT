import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly?

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "CatalogTabbarImage"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let servicesAssembly = servicesAssembly else {
            return
        }
        let catalogController = NFTCollectionListModuleFactory.build(serviceAssembly: servicesAssembly)
        let navigationViewController = UINavigationController(rootViewController: catalogController)
        catalogController.tabBarItem = catalogTabBarItem
        viewControllers = [navigationViewController]
        view.backgroundColor = .systemBackground
    }
}
