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

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let statisticTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistic", comment: ""),
        image: UIImage(named: "statisticTab"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let statisticController = StatisticBuilder.build()
        statisticController.tabBarItem = statisticTabBarItem

        let navigationController = UINavigationController(rootViewController: statisticController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.frame.size.height = 42
        
        viewControllers = [catalogController, navigationController]
        view.backgroundColor = .systemBackground
    }
}
