//
//  NFTCollectionDetailModuleBuilder.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

import UIKit

final class NFTCollectionDetailModuleBuilder {
    static func build(input: NftCollectionDetailInput, serviceAssembly: ServicesAssembly) -> NFTCollectionDetailViewController {
        let interactor = serviceAssembly.nftCollectionDetailInteractor
        let router = NFTCollectionDetailRouter()
        let presenter = NFTCollectionDetailPresenter(interactor: interactor, router: router)
        let viewController = NFTCollectionDetailViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
