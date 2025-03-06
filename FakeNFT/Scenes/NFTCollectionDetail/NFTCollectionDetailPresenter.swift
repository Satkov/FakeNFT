//
//  NFTCollectionDetailPresenter.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

import Foundation

protocol NFTCollectionDetailPresenterProtocol: AnyObject {
    func loadCurrentNFTCollection()
    func showAuthorPage()
    func nftCount() -> Int
    func nftBusinessObject(index: IndexPath) -> NftBusinessObject?
    func loadProfile()
}

final class NFTCollectionDetailPresenter {
    weak var view: NFTCollectionDetailViewProtocol?
    var router: NFTCollectionDetailRouterProtocol
    var interactor: NFTCollectionDetailInteractorProtocol
    var input: NftCollectionDetailInput
    
    private var currentNftCollection: NftCollection?
    private var users: [User]?
    private var authorWebsiteURL: URL?
    private var nfts: [Nft]? = []
    private var profile: Profile?
    private var order: Order?

    init(interactor: NFTCollectionDetailInteractorProtocol, router: NFTCollectionDetailRouterProtocol, input: NftCollectionDetailInput) {
        self.interactor = interactor
        self.router = router
        self.input = input
    }
}

extension NFTCollectionDetailPresenter: NFTCollectionDetailPresenterProtocol {
    
    func loadCurrentNFTCollection() {
        interactor.loadNftCollection(id: input.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nftCollection):
                self.loadUsers()
                self.currentNftCollection = nftCollection
                let url = URL(string: nftCollection.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                self.view?.updateNftCollectionInformation(name: nftCollection.name.capitalized,
                                                          imageURL: url,
                                                          description: nftCollection.description.capitalized, authorName: nftCollection.author)
                if let nftIds = self.currentNftCollection?.nfts {
                    for nftId in nftIds {
                        self.loadNft(id: nftId)
                    }
                }
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func loadUsers() {
        interactor.loadAllUsers{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.users = users
                _ = users.first (where: { $0.name == self.currentNftCollection?.author })
                //let correctAuthorWebsiteLink = user?.website.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                //TODO: I hardcoded link because data from server is incorrect, users list doesn't contain name nft collection's author
                let correctAuthorWebsiteLink = "https://practicum.yandex.ru/"
                self.authorWebsiteURL = URL(string: correctAuthorWebsiteLink)
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func showAuthorPage() {
        router.showAthorPage(url: authorWebsiteURL)
    }
    
    func nftCount() -> Int {
        return currentNftCollection?.nfts.count ?? 0
    }
    
    func loadNft(id: String) {
        interactor.loadNft(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nft):
                self.nfts?.append(nft)
                if self.nfts?.count == self.currentNftCollection?.nfts.count {
                    self.view?.updateNftList()
                }
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func nftBusinessObject(index: IndexPath) -> NftBusinessObject? {
        
        guard let nft = nfts?[index.row] else {
            return nil
        }
        let imageURL = URL(string: nft.images.first ?? "")
        let nftBO = NftBusinessObject(imageURL: imageURL,
                          name: nft.name,
                          price: nft.price,
                          rating: nft.rating,
                          isOrdered: order?.nfts.contains(nft.id) ?? false,
                          isLiked: profile?.likes.contains(nft.id) ?? false)
        return nftBO
    }
    
    func loadProfile() {
        interactor.loadProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                if self.nfts?.count == self.currentNftCollection?.nfts.count {
                    self.view?.updateNftList()
                }
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func loadOrder() {
        interactor.loadOrder { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.order = order
                if self.nfts?.count == self.currentNftCollection?.nfts.count {
                    self.view?.updateNftList()
                }
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
}
