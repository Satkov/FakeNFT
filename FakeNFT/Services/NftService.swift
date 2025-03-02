import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias UpdateOrderCompletion = (Result<UpdateOrderResponse, Error>) -> Void

protocol NftService {
    func sendUpdateOrderRequest(nfts: [String], completion: @escaping UpdateOrderCompletion)
    func loadNft(id: String, completion: @escaping NftCompletion)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
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
