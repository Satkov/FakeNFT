import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias UpdateOrderCompletion = (Result<UpdateOrderResponse, Error>) -> Void

protocol NftService {
    func sendUpdateOrderRequest(nfts: [String], completion: @escaping UpdateOrderCompletion)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
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
