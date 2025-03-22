import UIKit
import ProgressHUD
import Foundation

protocol ProfileEditPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave()
    func didTapClose()
    func profileLoaded(_ profile: Profile)
    func profileLoadFailed(error: Error)
    func didUpdate(avatarUrl: String)
    func didRemoveAvatar()
}

final class ProfileEditPresenter: ProfileEditPresenterProtocol {
    weak var view: ProfileEditViewProtocol?
    var interactor: ProfileEditInteractorInput
    var router: ProfileEditRouterProtocol
    var onProfileUpdated: ((Profile) -> Void)?
    
    private var profile: Profile?

    init(interactor: ProfileEditInteractorInput, router: ProfileEditRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        interactor.loadProfile()
    }
    
    func didTapSave() {
        view?.showLoadingIndicator()
        let updatedProfile = Profile(
            name: view?.nameText ?? "",
            avatar: profile?.avatar ?? "",
            description: view?.descriptionText ?? "",
            website: view?.websiteText ?? "",
            nfts: profile?.nfts ?? [],
            likes: profile?.likes ?? [],
            id: "1"
        )
        onProfileUpdated?(updatedProfile)
    }
    
    func didTapClose() {
        router.closeProfileEdit()
    }
    
    func profileLoaded(_ profile: Profile) {
        self.profile = profile
        view?.hideLoadingIndicator()
        view?.showProfileData(profile)
    }
    
    func profileLoadFailed(error: Error) {
        view?.hideLoadingIndicator()
        view?.showError("Не удалось загрузить данные профиля.")
    }
    
    func didUpdate(avatarUrl: String) {
        guard let profile, let url = URL(string: avatarUrl) else {
            view?.showError("Ошибка загрузки изображения")
            return
        }
        
        url.isReachable { [weak self] isReachable in
            if isReachable {
                self?.interactor.update(avatarUrl: avatarUrl, of: profile)
            } else {
                self?.view?.showError("Ошибка загрузки изображения")
            }
        }
    }
    
    func didRemoveAvatar() {
        guard let profile else { return }
        interactor.update(avatarUrl: "", of: profile)
    }
}

