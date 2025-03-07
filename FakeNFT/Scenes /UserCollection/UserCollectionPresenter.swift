import Foundation

protocol UserCollectionPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class UserCollectionPresenter: UserCollectionPresenterProtocol {
    weak var view: UserCollectionViewProtocol?
    private let interactor: UserCollectionInteractorProtocol
    private let router: UserCollectionRouterProtocol
    private let userId: String
    
    init(
        view: UserCollectionViewProtocol,
        interactor: UserCollectionInteractorProtocol,
        router: UserCollectionRouterProtocol,
        userId: String
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.userId = userId
    }
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        interactor.fetchNFTs(for: userId)
    }
}

extension UserCollectionPresenter: UserCollectionInteractorOutputProtocol {
    func didFetchNFTs(_ nfts: [NFT]) {
        view?.hideLoadingIndicator()
        view?.showNFTs(nfts)
    }
    
    func didFailFetchingNFTs(with error: Error) {
        view?.hideLoadingIndicator()
        view?.showError(error)
    }
}
