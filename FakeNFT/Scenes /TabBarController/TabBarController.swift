import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        servicesAssembly.nftService.loadCart { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
