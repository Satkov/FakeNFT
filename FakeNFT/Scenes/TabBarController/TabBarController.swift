import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly?

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "CatalogTabbarImage"),
        tag: 0
    )

    private let statisticTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistic", comment: ""),
        image: UIImage(named: "statisticTab"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let servicesAssembly = servicesAssembly else {
            return
        }

        let catalogController = NFTCollectionListModuleFactory.build(serviceAssembly: servicesAssembly)
        let catalogNavigationController = UINavigationController(rootViewController: catalogController)
        catalogController.tabBarItem = catalogTabBarItem

        let statisticController = StatisticBuilder.build()
        let statisticNavigationController = UINavigationController(rootViewController: statisticController)
        statisticController.tabBarItem = statisticTabBarItem

        statisticNavigationController.navigationBar.isTranslucent = false
        statisticNavigationController.navigationBar.barTintColor = .white
        statisticNavigationController.navigationBar.shadowImage = UIImage()
        statisticNavigationController.navigationBar.frame.size.height = 42

        viewControllers = [catalogNavigationController, statisticNavigationController]
        view.backgroundColor = .systemBackground
    }
}
