import UIKit

struct PaymentPageModuleFactory {
    static func build(servicesAssembly: ServicesAssembly) -> PaymentPageViewController {
        let interactor = PaymentPageInteractor(serviceAssembly: servicesAssembly)
        let router = PaymentPageRouter()
        let presenter = PaymentPagePresenter(interactor: interactor, router: router)
        let viewController = PaymentPageViewController()
        
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
