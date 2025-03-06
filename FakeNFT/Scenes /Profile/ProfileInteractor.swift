import Foundation

protocol ProfileInteractorProtocol: AnyObject {
    func fetchProfile(userId: String)
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
}
