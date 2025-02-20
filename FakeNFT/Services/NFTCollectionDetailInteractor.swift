//
//  NFTCollectionDetailInteractor.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

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
}
