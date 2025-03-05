//
//  ProfileEditInteractorInput.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 01.03.2025.
//


protocol ProfileEditInteractorInput: AnyObject {
    func loadProfile()
    func saveProfile(_ profile: ProfileEntity)
}

final class ProfileEditInteractor: ProfileEditInteractorInput {
    weak var presenter: ProfileEditPresenterProtocol?
    
    private let profileService: ProfileService

    init(profileService: ProfileService) {
        self.profileService = profileService
    }

    func loadProfile() {
        profileService.loadProfile(id: "1") { [weak self] result in
            guard let self = self else { return }
            switch (result) {
            case .success(let profile) :
                self.presenter?.profileLoaded(profile)
            case .failure(let error):
                self.presenter?.profileLoadFailed(error: error)
            }
        }
    }

    func saveProfile(_ profile: ProfileEntity) {
        profileService.updateProfile(profile) { [weak self] result in
            guard let self = self else { return }
            switch (result) {
            case .success(_) :
                self.presenter?.profileSaveSucceeded()
            case .failure(let error):
                self.presenter?.profileSaveFailed(error: error)
            }
        }
    }
}
