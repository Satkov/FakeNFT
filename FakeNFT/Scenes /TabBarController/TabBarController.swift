import UIKit

final class TabBarController: UITabBarController {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "cartTabBarIcon"),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "CatalogTabbarImage"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let cartController = CartModuleFactory.build(servicesAssembly: servicesAssembly)
        let catalogController = NFTCollectionListModuleFactory.build(serviceAssembly: servicesAssembly)

        let cartNavController = UINavigationController(rootViewController: cartController)
        cartNavController.tabBarItem = cartTabBarItem

        let catalogNavController = UINavigationController(rootViewController: catalogController)
        catalogNavController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogNavController, cartNavController]

        view.backgroundColor = .systemBackground
    }
}
