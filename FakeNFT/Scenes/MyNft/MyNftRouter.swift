protocol MyNftRouterProtocol {
    func routeToDetail(for nft: Nft)
}

final class MyNftRouter: MyNftRouterProtocol {
    weak var viewController: MyNftViewController?
    
    func routeToDetail(for nft: Nft) {
        // TODO: In next module
    }
    
    static func createModule() -> MyNftViewController {
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
