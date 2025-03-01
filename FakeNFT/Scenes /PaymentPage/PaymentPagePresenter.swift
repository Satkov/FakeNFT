protocol PaymentPagePresenterProtocol: AnyObject {
    func showWebView()
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
    func showWebView() {
        router.showWebView()
    }
}
