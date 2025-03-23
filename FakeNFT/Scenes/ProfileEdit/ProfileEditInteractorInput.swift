protocol ProfileEditInteractorInput: AnyObject {
    func loadProfile()
    func update(avatarUrl: String, of profile: Profile)
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
    
    func update(avatarUrl: String, of profile: Profile) {
        let profileWithUpdatedAvatar = Profile(name: profile.name, avatar: avatarUrl, description: profile.description, website: profile.website, nfts: profile.nfts, likes: profile.likes, id: "1")
        profileService.updateProfile(profileWithUpdatedAvatar) { [weak self] result in
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
