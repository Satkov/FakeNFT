import Foundation

protocol FavouriteNftInteractorProtocol: AnyObject {
    func loadFavouriteNft()
    func removeFromFavourite(_ favouriteNft: Nft)
}

final class FavouriteNftInteractor: FavouriteNftInteractorProtocol {
    weak var presenter: FavouriteNftPresenterProtocol?
    
    private let profile: Profile
    private let nftService: NftService
    
    init(profile: Profile, nftService: NftService) {
        self.profile = profile
        self.nftService = nftService
    }
    
    func loadFavouriteNft() {
        var nfts = [Nft]()
        let favouriteNftIds = profile.likes
        let dispatchGroup = DispatchGroup()
        var encounteredError: Error?
        
        for nftId in favouriteNftIds {
            dispatchGroup.enter()
            nftService.loadNft(id: nftId) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    encounteredError = error
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = encounteredError {
                self.presenter?.didFailFetchFavouriteNfts(error: error)
            } else {
                self.presenter?.didFetchFavouriteNfts(nfts)
            }
        }
    }
    
    func removeFromFavourite(_ favouriteNft: Nft) {
        // TODO
    }
}
