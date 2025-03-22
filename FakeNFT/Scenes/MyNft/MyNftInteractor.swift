import Foundation

protocol MyNftInteractorProtocol: AnyObject {
    func fetchNFTs()
    func removeFromFavourite(_ nft: MyNft)
    func addToFavourite(_ nft: MyNft)
}

final class MyNftInteractor: MyNftInteractorProtocol {
    weak var presenter: MyNftPresenterProtocol?
    
    private var profile: Profile
    private let nftService: NftService
    private let profileService: ProfileService
    
    init(profile: Profile, nftService: NftService, profileService: ProfileService) {
        self.profile = profile
        self.nftService = nftService
        self.profileService = profileService
    }
    
    func fetchNFTs() {
        var nfts = [MyNft]()
        let favouriteNftIds = profile.nfts
        let dispatchGroup = DispatchGroup()
        var encounteredError: Error?
        
        for nftId in favouriteNftIds {
            dispatchGroup.enter()
            nftService.loadNft(id: nftId) { result in
                switch result {
                case .success(let nft):
                    nfts.append(
                        MyNft(
                            name: nft.name,
                            image: nft.images[0],
                            rating: nft.rating,
                            price: nft.price,
                            author: nft.author,
                            id: nft.id,
                            isLiked: self.profile.likes.contains(nftId)
                        )
                    )
                case .failure(let error):
                    encounteredError = error
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = encounteredError {
                self.presenter?.didFailWith(error: error)
            } else {
                self.presenter?.didFetchNFTs(nfts)
            }
        }
    }
    
    func removeFromFavourite(_ nft: MyNft) {
        let likes = profile.likes.filter { $0 != nft.id }
        profileService.updateLikedNft(likes) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.didFailWith(error: error)
            case .success(let profile):
                self?.profile = profile
            }
        }
    }
    
    func addToFavourite(_ nft: MyNft) {
        var likes = profile.likes
        likes.append(nft.id)
        profileService.updateLikedNft(likes) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.didFailWith(error: error)
            case .success(let profile):
                self?.profile = profile
            }
        }
    }
}
