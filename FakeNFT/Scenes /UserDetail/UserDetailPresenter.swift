import Foundation
import UIKit

protocol UserDetailPresenterProtocol: AnyObject {
    func loadUserDetails()
    func openWebsite()
    func openCollection()
}

final class UserDetailPresenter: UserDetailPresenterProtocol {
    
    weak var view: UserDetailViewProtocol?
    private let interactor: UserDetailInteractorProtocol
    private let router: UserDetailRouterProtocol
    private let userId: String
    private var userDetail: UserDetail?
    
    init(view: UserDetailViewProtocol, interactor: UserDetailInteractorProtocol, router: UserDetailRouterProtocol, userId: String) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.userId = userId
    }
    
    func loadUserDetails() {
        interactor.fetchUserDetail(userId: userId)
    }
    
    func openWebsite() {
        guard let user = userDetail, !user.website.isEmpty else { return }
        router.openWebsite(url: user.website)
    }
    
    func openCollection() {
        guard let user = userDetail else { return }
        router.openCollection(userId: user.id)
    }
    
    private func prepareUserDetails(_ user: UserDetail) -> (String, NSAttributedString, String, URL?) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]
        
        let attributedDescription = NSAttributedString(string: user.description, attributes: attributes)
        let collectionText = "Коллекция NFT (\(user.nftCount))"
        let imageUrl = URL(string: user.avatar)
        
        return (user.name, attributedDescription, collectionText, imageUrl)
    }
}

extension UserDetailPresenter: UserDetailInteractorOutputProtocol {
    func didFetchUserDetail(_ user: UserDetail) {
        self.userDetail = user
        let userDetails = prepareUserDetails(user)
        
        view?.updateUserDetails(name: userDetails.0, description: userDetails.1, collectionText: userDetails.2, image: UIImage(named: "placeholder"))
        
        if let imageUrl = userDetails.3 {
            ImageLoader.shared.loadImage(from: imageUrl) { [weak self] image in
                self?.view?.updateUserImage(image)
            }
        }
    }
    
    func didFailFetchingUserDetail(with error: Error) {
        print("Ошибка загрузки пользователя: \(error.localizedDescription)")
    }
}
