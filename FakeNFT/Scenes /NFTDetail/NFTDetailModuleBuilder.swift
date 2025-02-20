//
//  NFTDetailModuleBuilder.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

import UIKit

class NFTDetailModuleBuilder {
    static func build(serviceAssembly: ServicesAssembly) -> NFTDetailViewController {
        let interactor = serviceAssembly.nftDetailInteractor
        let router = NFTDetailRouter()
        let presenter = NFTDetailPresenter(interactor: interactor, router: router)
        let viewController = NFTDetailViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
