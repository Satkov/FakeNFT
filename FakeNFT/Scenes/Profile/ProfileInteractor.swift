import Foundation

protocol ProfileInteractorProtocol: AnyObject {
    func fetchProfile(userId: String)
    func saveProfile(_ profile: Profile)
}

final class ProfileInteractor: ProfileInteractorProtocol {
    weak var presenter: ProfilePresenterProtocol?
    
    // MARK: - Private
    private let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    func fetchProfile(userId: String) {
        profileService.loadProfile(id: userId) { result in
            switch (result) {
            case .success(let profile):
                self.presenter?.didFetchProfile(profile)
            case .failure(let error):
                self.presenter?.didFailFetchingProfile(error: error)
            }
        }
    }
    
    func saveProfile(_ profile: Profile) {
        profileService.updateProfile(profile) { [weak self] result in
            guard let self = self else { return }
            switch (result) {
            case .success(let profile) :
                self.presenter?.didFetchProfile(profile)
            case .failure(let error):
                self.presenter?.didFailUpdateProfile(error: error)
            }
        }
    }
}
