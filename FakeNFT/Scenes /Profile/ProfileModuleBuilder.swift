//
//  ProfileModuleBuilder.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 24.02.2025
//

import UIKit

final class ProfileModuleBuilder {
    static func build(servicesAssembly: ServicesAssembly) -> ProfileViewController {
        let interactor = ProfileInteractor(profileService: servicesAssembly.profileService)
        let router = ProfileRouter(servicesAssembly: servicesAssembly)
        let presenter = ProfilePresenter(userId: "1", interactor: interactor, router: router)
        let viewController = ProfileViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
