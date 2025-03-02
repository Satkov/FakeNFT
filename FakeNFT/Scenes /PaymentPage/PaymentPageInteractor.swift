protocol PaymentPageInteractorProtocol: AnyObject {
    func getCurrency(completion: @escaping CurrencyCompletion)
    func setCurrencyIdAndPay(id: String, completion: @escaping payForOrderCompletion)
}

class PaymentPageInteractor: PaymentPageInteractorProtocol {
    weak var presenter: PaymentPagePresenterProtocol?
    private let servicesAssembly: ServicesAssembly

    init(
        serviceAssembly: ServicesAssembly
    ) {
        self.servicesAssembly = serviceAssembly
    }

    func getCurrency(completion: @escaping CurrencyCompletion) {
        servicesAssembly.nftService.getCurrency(completion: completion)
    }

    func setCurrencyIdAndPay(
        id: String,
        completion: @escaping payForOrderCompletion
    ) {
        servicesAssembly.nftService.setCurrencyIdAndPay(
            id: id,
            completion: completion
        )
    }
}
