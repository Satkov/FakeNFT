//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 24.02.2025
//

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didFetchProfile(_ profile: ProfileEntity)
    func didFailFetchingProfile(error: Error)
    func didTapEditButton()
    func didTapMyNftButton()
}

final class ProfilePresenter {
    weak var view: ProfileViewProtocol?
    var router: ProfileRouterProtocol
    var interactor: ProfileInteractorProtocol
    
    private let userId: String

    init(userId: String, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.userId = userId
        self.interactor = interactor
        self.router = router
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor.fetchProfile(userId: userId)
    }
    
    func didFetchProfile(_ profile: ProfileEntity) {
        view?.hideLoading()
        view?.showProfile(profile)
    }

    func didFailFetchingProfile(error: Error) {
        view?.hideLoading()
        
        let message = error.localizedDescription
        view?.showError(message)
    }
    
    func didTapEditButton() {
        router.openProfileEdit(withUserId: userId)
    }
    
    func didTapMyNftButton() {
        router.openMyNft()
    }
}
