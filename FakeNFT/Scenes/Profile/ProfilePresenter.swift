protocol ProfileState {
    func handle(presenter: ProfilePresenter)
}

final class LoadingState: ProfileState {
    func handle(presenter: ProfilePresenter) {
        presenter.view?.showLoading()
    }
}

final class LoadedState: ProfileState {
    private let profile: Profile

    init(profile: Profile) {
        self.profile = profile
    }

    func handle(presenter: ProfilePresenter) {
        presenter.view?.hideLoading()
        presenter.view?.showProfile(profile)
    }
}

final class ErrorState: ProfileState {
    private let error: Error

    init(error: Error) {
        self.error = error
    }

    func handle(presenter: ProfilePresenter) {
        presenter.view?.hideLoading()
        presenter.view?.showError(error.localizedDescription)
    }
}

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didFetchProfile(_ profile: Profile)
    func didFailFetchingProfile(error: Error)
    func didTapEditButton()
    func didTapMyNftButton()
}

final class ProfilePresenter {
    weak var view: ProfileViewProtocol?
    var router: ProfileRouterProtocol
    var interactor: ProfileInteractorProtocol
    
    private let userId: String
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
    
    func didFetchProfile(_ profile: Profile) {
        state = LoadedState(profile: profile)
        state.handle(presenter: self)
    }

    func didFailFetchingProfile(error: Error) {
        state = ErrorState(error: error)
        state.handle(presenter: self)
    }
    
    func didTapEditButton() {
        router.openProfileEdit(withUserId: userId)
    }
    
    func didTapMyNftButton() {
        router.openMyNft()
    }
}
