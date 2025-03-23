import Foundation

protocol ProfileState {
    func handle(presenter: ProfilePresenter)
}

final class LoadingState: ProfileState {
    func handle(presenter: ProfilePresenter) {
        presenter.view?.showLoadingIndicator()
    }
}

final class LoadedState: ProfileState {
    private let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    func handle(presenter: ProfilePresenter) {
        presenter.view?.hideLoadingIndicator()
        presenter.view?.showProfile(profile)
    }
}

final class ErrorState: ProfileState {
    private let error: Error
    
    init(error: Error) {
        self.error = error
    }
    
    func handle(presenter: ProfilePresenter) {
        presenter.view?.hideLoadingIndicator()
        presenter.view?.showError(error.localizedDescription)
    }
}

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidApear()
    
    func didFetchProfile(_ profile: Profile)
    func didFailFetchingProfile(error: Error)
    func didTapEditButton()
    func didTapMyNftButton()
    func didTapLikedNftButton()
    func didTapAboutDevButton()
    func didFailUpdateProfile(error: Error)
}

final class ProfilePresenter {
    weak var view: ProfileViewProtocol?
    var router: ProfileRouterProtocol
    var interactor: ProfileInteractorProtocol
    
    private let userId: String
    private var profile: Profile? = nil
    private var state: ProfileState = LoadingState()
    
    init(userId: String, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.userId = userId
        self.interactor = interactor
        self.router = router
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        state.handle(presenter: self)
        interactor.fetchProfile(userId: userId)
    }
    
    func viewDidApear() {
        guard profile != nil else { return }
        interactor.fetchProfile(userId: userId)
    }
    
    func didFetchProfile(_ profile: Profile) {
        self.profile = profile
        state = LoadedState(profile: profile)
        state.handle(presenter: self)
    }
    
    func didFailFetchingProfile(error: Error) {
        state = ErrorState(error: error)
        state.handle(presenter: self)
    }
    
    func didTapEditButton() {
        router.openProfileEdit(withUserId: userId) { [weak self] profile in
            guard let self else {
                return
            }
            self.didFetchProfile(profile)
            self.interactor.saveProfile(profile)
        }
    }
    
    func didFailUpdateProfile(error: any Error) {
        state = ErrorState(error: error)
        state.handle(presenter: self)
        interactor.fetchProfile(userId: userId)
    }
    
    func didTapMyNftButton() {
        guard let profile else { return }
        router.openMyNft(profile)
    }
    
    func didTapLikedNftButton() {
        guard let profile else { return }
        router.openFavouriteNft(profile)
    }
    
    func didTapAboutDevButton() {
        router.openAboutDeveloper()
    }
}
