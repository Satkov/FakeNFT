protocol ProfileEditInteractorInput: AnyObject {
    func loadProfile()
}

final class ProfileEditInteractor: ProfileEditInteractorInput {
    weak var presenter: ProfileEditPresenterProtocol?
    
    private let profileService: ProfileService

    init(profileService: ProfileService) {
        self.profileService = profileService
    }

    func loadProfile() {
        profileService.loadProfile(id: "1") { [weak self] result in
            guard let self else { return }
            switch (result) {
            case .success(let profile) :
                self.presenter?.profileLoaded(profile)
            case .failure(let error):
                self.presenter?.profileLoadFailed(error: error)
            }
        }
    }
}
