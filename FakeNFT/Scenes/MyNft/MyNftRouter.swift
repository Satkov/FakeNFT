final class MyNftRouter {
    weak var viewController: MyNftViewController?
    
    static func createModule(ofProfile profile: Profile, servicesAssembly: ServicesAssembly) -> MyNftViewController {
        let interactor = MyNftInteractor(profile: profile, nftService: servicesAssembly.nftService, profileService: servicesAssembly.profileService)
        let router = MyNftRouter()
        let presenter = MyNftPresenter(interactor: interactor)
        let viewController = MyNftViewController()
        
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
