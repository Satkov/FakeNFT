//
//  MyNftRouter.swift
//  Super easy dev
//
//  Created by Alibi Mailan on 03.03.2025
//

protocol MyNftRouterProtocol {
    func routeToDetail(for nft: Nft)
}

class MyNftRouter: MyNftRouterProtocol {
    weak var viewController: MyNftViewController?
    
    func routeToDetail(for nft: Nft) {
    }
}
