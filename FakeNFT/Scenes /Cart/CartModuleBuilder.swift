import UIKit

class CartModuleBuilder {
    static func build() -> CartViewController {
        let interactor = CartInteractor()
        let router = CartRouter()
        let presenter = CartPresenter(interactor: interactor, router: router)
        let storyboard = UIStoryboard(name: "CartViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
