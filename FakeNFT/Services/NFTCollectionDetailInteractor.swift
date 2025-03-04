//
//  NFTCollectionDetailInteractor.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

typealias NftCollectionDetailCompletion = (Result<NftCollection, Error>) -> Void
typealias NftDetailCompletion = (Result<Nft, Error>) -> Void
typealias UserCompletion = (Result<User, Error>) -> Void
typealias UsersCompletion = (Result<[User], Error>) -> Void

protocol NFTCollectionDetailInteractorProtocol: AnyObject {
    func loadNftCollection(id: String, completion: @escaping NftCollectionDetailCompletion)
    func loadUser(userId: String, completion: @escaping UserCompletion)
    func loadAllUsers(completion: @escaping UsersCompletion)
    func loadNft(id: String, completion: @escaping NftDetailCompletion)
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
    
    func loadNftCollection(id: String, completion: @escaping NftCollectionDetailCompletion) {
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
    
    func loadUser(userId: String, completion: @escaping UserCompletion) {
        let request = UserRequest(id: userId)
        networkClient.send(request: request, type: User.self) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadAllUsers(completion: @escaping UsersCompletion) {
        let request = UsersRequest()
        networkClient.send(request: request, type: [User].self) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
}
