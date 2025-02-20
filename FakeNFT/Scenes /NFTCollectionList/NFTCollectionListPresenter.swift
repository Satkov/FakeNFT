//
//  NFTCollectionListPresenter.swift
//  Super easy dev
//
//  Created by Nikolay on 16.02.2025
//
import UIKit

protocol NFTCollectionListPresenterProtocol: AnyObject {
    func numberOfNFTCollections() -> Int
    func cellModelForIndex(_ indexPath: IndexPath) -> NFTCollectionCellModel?
    func loadNFTCollectionList()
    func sortNFTCollectionsByName()
    func sortNFTCollectionsByNftCount()
}

class NFTCollectionListPresenter {
    weak var view: NFTCollectionListViewProtocol?
    var router: NFTCollectionListRouterProtocol
    var interactor: NFTCollectionListInteractorProtocol
    
    private var nftCollectionList: [NftCollection]?

    init(interactor: NFTCollectionListInteractorProtocol, router: NFTCollectionListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension NFTCollectionListPresenter: NFTCollectionListPresenterProtocol {
    func numberOfNFTCollections() -> Int {
        return nftCollectionList?.count ?? 0
    }
    
    func cellModelForIndex(_ indexPath: IndexPath) -> NFTCollectionCellModel? {
        
        let nftCollection: NftCollection? = nftCollectionList?[indexPath.row]
        var imageURL: URL?
        if let imageURLString = nftCollection?.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            imageURL = URL(string: imageURLString)
        }
        let model = NFTCollectionCellModel(imageURL: imageURL,
                                           name: nftCollection?.name ?? "",
                                           nftCount: nftCollection?.nfts.count ?? 0)
        return model
    }
    
    func loadNFTCollectionList() {
        interactor.loadNftCollectionList { [weak self] result in
            guard let self = self else { return }
            switch(result) {
            case .success(let nftCollectionList):
                self.nftCollectionList = nftCollectionList
                self.view?.updateForNewData()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func sortNFTCollectionsByName() {
        nftCollectionList = nftCollectionList?.sorted(by: { return $0.name < $1.name })
        view?.updateForNewData()
    }
    
    func sortNFTCollectionsByNftCount() {
        nftCollectionList = nftCollectionList?.sorted(by: { return $0.nfts.count < $1.nfts.count })
        view?.updateForNewData()
    }
}
