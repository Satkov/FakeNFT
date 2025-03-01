import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias CurrencyCompletion = (Result<[Currency], Error>) -> Void
typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol NftService {
    func loadCart(completion: @escaping OrderCompletion)
    func getNFTById(id: String, completion: @escaping NftCompletion)
    func getCurrency(completion: @escaping CurrencyCompletion) 
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadCart(completion: @escaping OrderCompletion) {
        let request = NetworkRequests.getNFTInsideCart()
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getNFTById(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NetworkRequests.getNFTById(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCurrency(completion: @escaping CurrencyCompletion) {
        let request = NetworkRequests.getCurrencies()
        networkClient.send(request: request, type: [Currency].self) { result in
            switch result {
            case .success(let currency):
                completion(.success(currency))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
