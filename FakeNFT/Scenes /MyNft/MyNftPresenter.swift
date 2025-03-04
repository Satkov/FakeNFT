//
//  MyNftPresenter.swift
//  Super easy dev
//
//  Created by Alibi Mailan on 03.03.2025
//

enum SortOption {
    case name
    case price
    case rating
}

protocol MyNftPresenterProtocol: AnyObject {
    var nftList: [Nft] { get }

    func viewDidLoad()
    func didSelectNFT(at index: Int)
    func didPullToRefresh()
    func didChangeSortOption(_ option: SortOption)
    func didFetchNFTs(_ nfts: [Nft])
    func didFailToFetchNFTs(error: Error?)
}

class MyNftPresenter {
    weak var view: MyNftViewProtocol?
    var router: MyNftRouterProtocol
    var interactor: MyNftInteractorProtocol
    
    private(set) var nftList: [Nft] = []
    private var currentSort: SortOption = .name
    
    init(interactor: MyNftInteractorProtocol, router: MyNftRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension MyNftPresenter: MyNftPresenterProtocol {
    
    func viewDidLoad() {
        interactor.fetchNFTs()
    }
    
    func didFetchNFTs(_ nfts: [Nft]) {
        self.nftList = nfts
        applySorting()
        view?.showNFTs(nftList)
    }
    
    func didFailToFetchNFTs(error: Error?) {
        let message = error?.localizedDescription ?? "Не удалось загрузить данные NFT."
        view?.showError(message)
    }
    
    func didSelectNFT(at index: Int) {
        guard index < nftList.count else { return }
        let selectedNFT = nftList[index]
        router.routeToDetail(for: selectedNFT)
    }
    
    func didPullToRefresh() {
        interactor.fetchNFTs()
    }
    
    func didChangeSortOption(_ option: SortOption) {
        currentSort = option
        applySorting()
        view?.showNFTs(nftList)
    }
    
    private func applySorting() {
        switch currentSort {
        case .name:
            nftList.sort(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })
        case .price:
            nftList.sort(by: { $0.price < $1.price })
        case .rating:
            nftList.sort(by: { $0.rating < $1.rating })
        }
    }
}
