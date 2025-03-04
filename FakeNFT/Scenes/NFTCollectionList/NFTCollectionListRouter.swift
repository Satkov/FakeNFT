//
//  NFTCollectionListRouter.swift
//  Super easy dev
//
//  Created by Nikolay on 16.02.2025
//

import UIKit

protocol NFTCollectionListRouterProtocol {
    func showNftCollectionDetail(nftCollectionDetailInput: NftCollectionDetailInput)
}

final class NFTCollectionListRouter: NFTCollectionListRouterProtocol {
    weak var viewController: NFTCollectionListViewController?
    
    private let serviceAssemby: ServicesAssembly
    
    init(serviceAssemby: ServicesAssembly) {
        self.serviceAssemby = serviceAssemby
    }
    
    func showNftCollectionDetail(nftCollectionDetailInput: NftCollectionDetailInput) {
        let nftCollectionDetailViewController = NFTCollectionDetailModuleBuilder.build(input: nftCollectionDetailInput, serviceAssembly: serviceAssemby)
        
        if let navigationViewController = viewController?.parent as? UINavigationController {
            navigationViewController.navigationBar.tintColor = UIColor.textPrimary
            navigationViewController.pushViewController(nftCollectionDetailViewController, animated: true)
        }
    }
}
