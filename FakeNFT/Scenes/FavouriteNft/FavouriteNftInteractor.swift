import Foundation

protocol FavouriteNftInteractorProtocol: AnyObject {
    func loadFavouriteNft()
    func removeFromFavourite(_ favouriteNft: Nft)
}

final class FavouriteNftInteractor: FavouriteNftInteractorProtocol {
    weak var presenter: FavouriteNftPresenterProtocol?
    
    private var profile: Profile
    private let nftService: NftService
    private let profileService: ProfileService
    
    init(profile: Profile, nftService: NftService, profileService: ProfileService) {
        self.profile = profile
        self.nftService = nftService
        self.profileService = profileService
    }
    
    func loadFavouriteNft() {
        var nfts = [Nft]()
        let favouriteNftIds = profile.likes
        let dispatchGroup = DispatchGroup()
        var encounteredError: Error?
        
        for nftId in favouriteNftIds {
            dispatchGroup.enter()
            nftService.getNFTById(id: nftId) { result in
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
        let likes = profile.likes.filter { $0 != favouriteNft.id }
        profileService.updateLikedNft(likes) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.didFailUnlikeNft(error: error)
            case .success(let profile):
                self?.profile = profile
                self?.presenter?.didUpdatedFavouriteNfts()
            }
        }
    }
}
