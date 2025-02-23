protocol CartInteractorProtocol: AnyObject {
    func getNFTInsideCart(completion: @escaping OrderCompletion)
    func getNFTByID(id: String, completion: @escaping NftCompletion)
}

class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol?
    private let serviceAssemply: ServicesAssembly

    init(
        serviceAssemply: ServicesAssembly
    ) {
        self.serviceAssemply = serviceAssemply
    }

    func getNFTInsideCart(completion: @escaping OrderCompletion) {
        serviceAssemply.nftService.loadCart() { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getNFTByID(id: String, completion: @escaping NftCompletion) {
        serviceAssemply.nftService.getNFTById(id: id) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
