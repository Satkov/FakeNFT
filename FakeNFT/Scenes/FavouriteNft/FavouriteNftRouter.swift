protocol FavouriteNftRouterProtocol {
}

final class FavouriteNftRouter: FavouriteNftRouterProtocol {
    weak var viewController: FavouriteNftViewController?
    
    public static func createModule(ofProfile profile: Profile, servicesAssembly: ServicesAssembly) -> FavouriteNftViewController {
        let interactor = FavouriteNftInteractor(profile: profile, nftService: servicesAssembly.nftService)
        let router = FavouriteNftRouter()
        let presenter = FavouriteNftPresenter(interactor: interactor, router: router)
        let viewController = FavouriteNftViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
