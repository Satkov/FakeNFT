final class FavouriteNftRouter {
    weak var viewController: FavouriteNftViewController?
    
    static func createModule(ofProfile profile: Profile, servicesAssembly: ServicesAssembly) -> FavouriteNftViewController {
        let interactor = FavouriteNftInteractor(profile: profile, nftService: servicesAssembly.nftService, profileService: servicesAssembly.profileService)
        let router = FavouriteNftRouter()
        let presenter = FavouriteNftPresenter(interactor: interactor)
        let viewController = FavouriteNftViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
