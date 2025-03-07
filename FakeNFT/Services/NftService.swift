import Foundation

typealias UpdateOrderCompletion = (Result<UpdateOrderResponse, Error>) -> Void
typealias CartCompletion = (Result<Order, Error>) -> Void

protocol NftService {
    func loadCart(completion: @escaping OrderCompletion)
    func sendUpdateOrderRequest(nfts: [String], completion: @escaping UpdateOrderCompletion)
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

    func sendUpdateOrderRequest(
        nfts: [String],
        completion: @escaping UpdateOrderCompletion
    ) {
        let dto = UpdateOrderDto(nfts: nfts)
        let request = NetworkRequests.putOrder1(dto: dto)
        networkClient.send(request: request, type: UpdateOrderResponse.self) { result in
            switch result {
            case .success(let putResponse):
                completion(.success(putResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
