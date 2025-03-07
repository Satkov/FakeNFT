import Foundation

protocol UserCollectionInteractorProtocol: AnyObject {
    var presenter: UserCollectionInteractorOutputProtocol? { get set }
    func fetchNFTs(for userId: String)
}

protocol UserCollectionInteractorOutputProtocol: AnyObject {
    func didFetchNFTs(_ nfts: [NFT])
    func didFailFetchingNFTs(with error: Error)
}

final class UserCollectionInteractor: UserCollectionInteractorProtocol {
    weak var presenter: UserCollectionInteractorOutputProtocol?
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchNFTs(for userId: String) {
        let request = UserDetailRequest(userId: userId)
        
        networkClient.send(request: request, type: UserDetail.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let user):
                self.fetchNFTs(for: user.nfts)
            case .failure(let error):
                self.presenter?.didFailFetchingNFTs(with: error)
            }
        }
    }
    
    private func fetchNFTs(for nftIds: [String]) {
        var nfts: [NFT] = []
        let group = DispatchGroup()
        
        for nftId in nftIds {
            group.enter()
            let request = UserCollectionRequest(nftId: nftId)
            networkClient.send(request: request, type: NFT.self) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    print("Interactor: Ошибка загрузки NFT \(nftId): \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.presenter?.didFetchNFTs(nfts)
        }
    }
}
