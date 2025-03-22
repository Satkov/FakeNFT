protocol MyNftPresenterProtocol: AnyObject {
    var nftList: [MyNft] { get }

    func viewDidLoad()
    func didToggleLike(at index: Int)
    func didChangeSortOption(_ option: MyNftSortOption)
    func didFetchNFTs(_ nfts: [MyNft])
    func didFailWith(error: Error?)
}

final class MyNftPresenter {
    weak var view: MyNftViewProtocol?
    var interactor: MyNftInteractorProtocol
    
    private(set) var nftList: [MyNft] = []
    private var currentSort: MyNftSortOption = .name
    
    init(interactor: MyNftInteractorProtocol) {
        self.interactor = interactor
    }
}

extension MyNftPresenter: MyNftPresenterProtocol {
    
    func viewDidLoad() {
        view?.showLoading()
        interactor.fetchNFTs()
    }
    
    func didFetchNFTs(_ nfts: [MyNft]) {
        self.nftList = nfts
        applySorting()
        view?.hideLoading()
        view?.showNFTs(nftList)
    }
    
    func didFailWith(error: Error?) {
        view?.hideLoading()
        let message = error?.localizedDescription ?? "Не удалось загрузить данные NFT."
        view?.showError(message)
    }
    
    func didToggleLike(at index: Int) {
        guard index < nftList.count else { return }
        var selectedNFT = nftList[index]
        if selectedNFT.isLiked {
            interactor.removeFromFavourite(selectedNFT)
        } else {
            interactor.addToFavourite(selectedNFT)
        }
        selectedNFT.isLiked = !selectedNFT.isLiked
        nftList[index] = selectedNFT
        view?.showNFTs(nftList)
    }

    func didChangeSortOption(_ option: MyNftSortOption) {
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
