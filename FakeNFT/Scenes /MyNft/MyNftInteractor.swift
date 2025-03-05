//
//  MyNftInteractor.swift
//  Super easy dev
//
//  Created by Alibi Mailan on 03.03.2025
//

protocol MyNftInteractorProtocol: AnyObject {
    func fetchNFTs()
}

class MyNftInteractor: MyNftInteractorProtocol {
    weak var presenter: MyNftPresenterProtocol?

    private let mockNFTs: [Nft] = [
        Nft(id: "1", price: 1.78, rating: 3, name: "Lilo", author: "John Doe", images: []),
        Nft(id: "2", price: 2.41, rating: 4, name: "Spring", author: "John Doe", images: []),
        Nft(id: "3", price: 0.64, rating: 2, name: "April", author: "John Doe", images: []),
    ]

    func fetchNFTs() {
        presenter?.didFetchNFTs(mockNFTs)
    }
}
