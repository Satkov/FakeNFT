protocol PaymentPageInteractorProtocol: AnyObject {
    func getCurrency(completion: @escaping CurrencyCompletion)
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
        servicesAssembly.nftService.getCurrency { result in
            switch result {
            case .success(let currency):
                completion(.success(currency))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
