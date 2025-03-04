//
//  ProfileEditModuleBuilder.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 03.03.2025.
//

import UIKit

final class ProfileEditModuleBuilder {
    func createProfileEditModule(servicesAssembly: ServicesAssembly, userId: String) -> UIViewController {
        let view = ProfileEditViewController()
        let presenter = ProfileEditPresenter()
        let router = ProfileEditRouter()
        let interactor = ProfileEditInteractor(profileService: servicesAssembly.profileService)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
