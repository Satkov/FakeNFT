protocol FavouriteNftPresenterProtocol: AnyObject {
    var favouriteNfts: [Nft] { get }
    func viewDidLoad()
    func didFailUnlikeNft(error: Error)
    func didFetchFavouriteNfts(_ nfts: [Nft])
    func didUpdatedFavouriteNfts()
    func didFailFetchFavouriteNfts(error: Error)
    func updateFavoriteStatus(favouriteNft: Nft)
}

final class FavouriteNftPresenter {
    weak var view: FavouriteNftViewProtocol?
    var interactor: FavouriteNftInteractorProtocol

    private(set) var favouriteNfts: [Nft] = []
    
    init(interactor: FavouriteNftInteractorProtocol) {
        self.interactor = interactor
    }
}

extension FavouriteNftPresenter: FavouriteNftPresenterProtocol {
    func viewDidLoad() {
        view?.showLoadingIndicator()
        interactor.loadFavouriteNft()
    }
    
    func didFetchFavouriteNfts(_ nfts: [Nft]) {
        self.favouriteNfts = nfts
        view?.hideLoadingIndicator()
        view?.updateForNewData()
    }
    
    func didFailFetchFavouriteNfts(error: any Error) {
        view?.hideLoadingIndicator()
        view?.showError(error.localizedDescription)
    }
    
    func updateFavoriteStatus(favouriteNft: Nft) {
        favouriteNfts = favouriteNfts.filter { $0.id != favouriteNft.id }
        interactor.removeFromFavourite(favouriteNft)
        view?.showLoadingIndicator()
    }
    
    func didUpdatedFavouriteNfts() {
        view?.hideLoadingIndicator()
        view?.updateForNewData()
    }
    
    func didFailUnlikeNft(error: any Error) {
        view?.hideLoadingIndicator()
        view?.showError(error.localizedDescription)
    }
}
