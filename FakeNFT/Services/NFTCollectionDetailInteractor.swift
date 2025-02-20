//
//  NFTCollectionDetailInteractor.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

typealias NftCollectionDetailCompletion = (Result<NftCollection, Error>) -> Void

protocol NFTCollectionDetailInteractorProtocol: AnyObject {
}

class NFTCollectionDetailInteractor: NFTCollectionDetailInteractorProtocol {
    weak var presenter: NFTCollectionDetailPresenterProtocol?
    
    // MARK: - Private Properties
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
    // MARK: - Initializers
    init(networkClient: NetworkClient, nftStorage: NftStorage) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }
    
    func loadNftCollectionList(id: String, completion: @escaping NftCollectionDetailCompletion) {
        let request = NFTCollectionDetailRequest(id: id)
        networkClient.send(request: request, type: NftCollection.self) { result in
            switch result {
            case .success(let nftCollection):
                completion(.success(nftCollection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
