protocol PaymentPageInteractorProtocol: AnyObject {
}

class PaymentPageInteractor: PaymentPageInteractorProtocol {
    weak var presenter: PaymentPagePresenterProtocol?
}
