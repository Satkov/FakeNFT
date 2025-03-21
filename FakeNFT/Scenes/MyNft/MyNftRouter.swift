protocol MyNftRouterProtocol {
    func routeToDetail(for nft: Nft)
}

final class MyNftRouter: MyNftRouterProtocol {
    weak var viewController: MyNftViewController?
    
    func routeToDetail(for nft: Nft) {
        // TODO: In next module
    }
    
    static func createModule(ofProfile profile: Profile, servicesAssembly: ServicesAssembly) -> MyNftViewController {
        let interactor = MyNftInteractor(profile: profile, nftService: servicesAssembly.nftService, profileService: servicesAssembly.profileService)
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
