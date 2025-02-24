import UIKit

final class CartModuleBuilder {
    static func build(servicesAssembly: ServicesAssembly) -> CartViewController {
        let interactor = CartInteractor(serviceAssemply: servicesAssembly)
        let router = CartRouter()
        let presenter = CartPresenter(interactor: interactor, router: router)
        let viewController = CartViewController()
        presenter.attachView(viewController)
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
