//
//  NFTCollectionListModuleBuilder.swift
//  Super easy dev
//
//  Created by Nikolay on 16.02.2025
//

import UIKit

class NFTCollectionListModuleBuilder {
    static func build(serviceAssembly: ServicesAssembly) -> NFTCollectionListViewController {
        let interactor = serviceAssembly.nftCollectionListInteractor
        let router = NFTCollectionListRouter()
        let presenter = NFTCollectionListPresenter(interactor: interactor, router: router)
        let viewController = NFTCollectionListViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
