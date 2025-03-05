//
//  ProfileEditPresenterProtocol.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 01.03.2025.
//

import UIKit
import ProgressHUD

protocol ProfileEditPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave(name: String, description: String, website: String, photo: UIImage?)
    func didTapChangePhoto()
    func didTapClose()
    func profileLoaded(_ profile: ProfileEntity)
    func profileLoadFailed(error: Error)
    func profileSaveSucceeded()
    func profileSaveFailed(error: Error)
}

final class ProfileEditPresenter: ProfileEditPresenterProtocol {
    weak var view: ProfileEditViewProtocol?
    var interactor: ProfileEditInteractorInput!
    var router: ProfileEditRouterProtocol!
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        interactor.loadProfile()
    }
    
    func didTapSave(name: String, description: String, website: String, photo: UIImage?) {
        view?.showLoadingIndicator()
        let updatedProfile = ProfileEntity(id: "1", name: name, website: website, description: description, avatarURL: nil, nfts: nil)
        interactor.saveProfile(updatedProfile)
    }
    
    func didTapChangePhoto() {
        router.openImagePicker()
    }

    func profileLoaded(_ profile: ProfileEntity) {
        view?.hideLoadingIndicator()
        view?.showProfileData(profile)
    }
    
    func profileLoadFailed(error: Error) {
        view?.hideLoadingIndicator()
        view?.showError("Не удалось загрузить данные профиля.")
    }
    
    func profileSaveSucceeded() {
        view?.hideLoadingIndicator()
        ProgressHUD.showSucceed("Сохранено")
        router.closeProfileEdit()
    }
    
    func profileSaveFailed(error: Error) {
        view?.hideLoadingIndicator()
        view?.showError("Не удалось сохранить изменения.")
    }
    
    func didTapClose() {
        router.closeProfileEdit()
    }
}
