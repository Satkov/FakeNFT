//
//  MyNftModuleBuilder.swift
//  Super easy dev
//
//  Created by Alibi Mailan on 03.03.2025
//

import UIKit

class MyNftModuleBuilder {
    static func build() -> MyNftViewController {
        let interactor = MyNftInteractor()
        let router = MyNftRouter()
        let presenter = MyNftPresenter(interactor: interactor, router: router)
        let viewController = MyNftViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
