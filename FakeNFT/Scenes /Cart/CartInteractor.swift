protocol CartInteractorProtocol: AnyObject {
    func getNFTInsideCart(completion: @escaping OrderCompletion)
    func getNFTByID(id: String, completion: @escaping NftCompletion)
}

final class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol?
    private let servicesAssembly: ServicesAssembly

    init(
        serviceAssembly: ServicesAssembly
    ) {
        self.servicesAssembly = serviceAssembly
    }

    func getNFTInsideCart(completion: @escaping OrderCompletion) {
        servicesAssembly.nftService.loadCart { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getNFTByID(id: String, completion: @escaping NftCompletion) {
        servicesAssembly.nftService.getNFTById(id: id) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
