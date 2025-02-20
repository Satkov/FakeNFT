//
//  NFTDetailInteractor.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

typealias NftDetailCompletion = (Result<Nft, Error>) -> Void
typealias CurrenciesCompletion = (Result<[Currency], Error>) -> Void
typealias UserCompletion = (Result<User, Error>) -> Void

protocol NFTDetailInteractorProtocol: AnyObject {
}

class NFTDetailInteractor: NFTDetailInteractorProtocol {
    
    // MARK: - Public Properties
    weak var presenter: NFTDetailPresenterProtocol?
    
    // MARK: - Private Properties
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    // MARK: - Initializers
    init(networkClient: NetworkClient, nftStorage: NftStorage) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }
    
    func loadNft(id: String, completion: @escaping NftDetailCompletion) {
        let request = NFTDetailRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCurrencies(completion: @escaping CurrenciesCompletion) {
        let request = CurrenciesRequest()
        networkClient.send(request: request, type: [Currency].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadUser(completion: @escaping UserCompletion) {
        let request = CurrenciesRequest()
        networkClient.send(request: request, type: User.self) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
