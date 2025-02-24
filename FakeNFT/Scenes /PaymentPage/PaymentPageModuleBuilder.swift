import UIKit

class PaymentPageModuleBuilder {
    static func build() -> PaymentPageViewController {
        let interactor = PaymentPageInteractor()
        let router = PaymentPageRouter()
        let presenter = PaymentPagePresenter(interactor: interactor, router: router)
        let storyboard = UIStoryboard(name: "PaymentPage", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PaymentPage") as! PaymentPageViewController
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
