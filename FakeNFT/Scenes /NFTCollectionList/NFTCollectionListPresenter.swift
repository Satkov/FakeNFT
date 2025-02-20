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
        
//        guard let url = URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png") else {
//            return nil
//        }
        //let model = NFTCollectionCellModel(imageURL: url, name: "Peach", nftCount: 5)
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
    }
}
