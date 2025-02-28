protocol PaymentPagePresenterProtocol: AnyObject {
}

class PaymentPagePresenter {
    weak var view: PaymentPageViewProtocol?
    var router: PaymentPageRouterProtocol
    var interactor: PaymentPageInteractorProtocol

    init(interactor: PaymentPageInteractorProtocol, router: PaymentPageRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension PaymentPagePresenter: PaymentPagePresenterProtocol {
}
