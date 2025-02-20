//
//  NFTCollectionDetailPresenter.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

protocol NFTCollectionDetailPresenterProtocol: AnyObject {
}

class NFTCollectionDetailPresenter {
    weak var view: NFTCollectionDetailViewProtocol?
    var router: NFTCollectionDetailRouterProtocol
    var interactor: NFTCollectionDetailInteractorProtocol

    init(interactor: NFTCollectionDetailInteractorProtocol, router: NFTCollectionDetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension NFTCollectionDetailPresenter: NFTCollectionDetailPresenterProtocol {
}
