//
//  NFTCollectionListPresenter.swift
//  Super easy dev
//
//  Created by Nikolay on 16.02.2025
//
import UIKit

enum SortType: Int {
    case none
    case name
    case nftCount
}

protocol NFTCollectionListPresenterProtocol: AnyObject {
    func numberOfNFTCollections() -> Int
    func cellModelForIndex(_ indexPath: IndexPath) -> NFTCollectionCellModel?
    func loadNFTCollectionList()
    func sortNftCollectionList(type: SortType)
    func showNftCollectionDetailForIndexPath(_ indexPath: IndexPath)
}

final class NFTCollectionListPresenter {
    
    // MARK: - Public Properties
    weak var view: NFTCollectionListViewProtocol?
    var router: NFTCollectionListRouterProtocol
    var interactor: NFTCollectionListInteractorProtocol
    
    // MARK: - Private Properties
    private var nftCollectionList: [NftCollection]?

    // MARK: - Initializers
    init(interactor: NFTCollectionListInteractorProtocol, router: NFTCollectionListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - NFTCollectionListPresenterProtocol
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
            switch result {
            case .success(let nftCollectionList):
                self.nftCollectionList = nftCollectionList
                self.sortNftCollectionList(type: .none)
                self.view?.updateForNewData()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func sortNftCollectionList(type: SortType) {
        
        var currentType = type
        if type == .none {
            let savedSortType = SortType(rawValue: UserDefaults.standard.integer(forKey: "sortType"))
            if savedSortType == SortType.none {
                currentType = .nftCount
            } else if let savedSortType = savedSortType {
                currentType = savedSortType
            }
        }
        
        UserDefaults.standard.set(currentType.rawValue, forKey: "sortType")
        
        switch(currentType) {
        case .name:
            nftCollectionList = nftCollectionList?.sorted(by: { return $0.name < $1.name })
        case .nftCount:
            nftCollectionList = nftCollectionList?.sorted(by: { return $0.nfts.count < $1.nfts.count })
        default:
            break
        }
        
        view?.updateForNewData()
    }
    
    func showNftCollectionDetailForIndexPath(_ indexPath: IndexPath) {
        if let nftCollection = nftCollectionList?[indexPath.row] {
            let nftCollectionDetailInput = NftCollectionDetailInput(id: nftCollection.id)
            router.showNftCollectionDetail(nftCollectionDetailInput: nftCollectionDetailInput)
        }
    }
}
