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
        let catalogController = NFTCollectionListModuleBuilder.build(serviceAssembly: servicesAssembly)
        catalogController.tabBarItem = catalogTabBarItem
       // let vc = TestCatalogViewController(servicesAssembly: servicesAssembly)
        viewControllers = [catalogController]
        //viewControllers = [vc]
        view.backgroundColor = .systemBackground
    }
}
