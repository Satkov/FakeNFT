import UIKit
import ProgressHUD

protocol ProfileEditPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave(_ profileData: ProfileSaveData)
    func didTapChangePhoto()
    func didTapClose()
    func profileLoaded(_ profile: Profile)
    func profileLoadFailed(error: Error)
}

final class ProfileEditPresenter: ProfileEditPresenterProtocol {
    weak var view: ProfileEditViewProtocol?
    var interactor: ProfileEditInteractorInput
    var router: ProfileEditRouterProtocol
    var onProfileUpdated: ((Profile) -> Void)?

    init(interactor: ProfileEditInteractorInput, router: ProfileEditRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        interactor.loadProfile()
    }
    
    func didTapSave(_ profileData: ProfileSaveData) {
        view?.showLoadingIndicator()
        let updatedProfile = Profile(
            name: profileData.name,
            avatar: "avatar",
            description: profileData.description,
            website: profileData.website,
            nfts: [],
            likes: [],
            id: "1"
        )
        onProfileUpdated?(updatedProfile)
    }
    
    func didTapChangePhoto() {
        router.openImagePicker()
    }
    
    func didTapClose() {
        router.closeProfileEdit()
    }
    
    func profileLoaded(_ profile: Profile) {
        view?.hideLoadingIndicator()
        view?.showProfileData(profile)
    }
    
    func profileLoadFailed(error: Error) {
        view?.hideLoadingIndicator()
        view?.showError("Не удалось загрузить данные профиля.")
    }
}

