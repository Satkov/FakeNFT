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

    override func viewDidLoad() {
        super.viewDidLoad()

        let cart = CartModuleBuilder.build(servicesAssembly: servicesAssembly)
        let cartNavController = UINavigationController(rootViewController: cart)
        cartNavController.tabBarItem = cartTabBarItem

        viewControllers = [cartNavController]

        view.backgroundColor = .systemBackground
    }
}
