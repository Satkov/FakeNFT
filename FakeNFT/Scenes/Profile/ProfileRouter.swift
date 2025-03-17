protocol ProfileRouterProtocol {
    func openProfileEdit(withUserId userId: String, onProfileUpdated callback: @escaping (Profile) -> Void)
    func openMyNft()
    func openFavouriteNft(_ profile: Profile)
}

final class ProfileRouter: ProfileRouterProtocol {
    weak var viewController: ProfileViewController?
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func openProfileEdit(withUserId userId: String, onProfileUpdated callback: @escaping (Profile) -> Void) {
        guard let vc = viewController else { return }
        let profileEditVC = ProfileEditRouter.createModule(servicesAssembly: servicesAssembly, userId: userId, onProfileUpdated: callback)
        vc.present(profileEditVC, animated: true, completion: nil)
    }
    
    func openMyNft() {
        guard let vc = viewController else { return }
        let myNftVC = MyNftRouter.createModule()
        vc.navigationController?.pushViewController(myNftVC, animated: true)
    }
    
    func openFavouriteNft(_ profile: Profile) {
        guard let vc = viewController else { return }
        let favouriteNftVC = FavouriteNftRouter.createModule(ofProfile: profile, servicesAssembly: servicesAssembly)
        vc.navigationController?.pushViewController(favouriteNftVC, animated: true)
    }
    
    static func createModule(servicesAssembly: ServicesAssembly) -> ProfileViewController {
        let interactor = ProfileInteractor(profileService: servicesAssembly.profileService)
        let router = ProfileRouter(servicesAssembly: servicesAssembly)
        let presenter = ProfilePresenter(userId: "1", interactor: interactor, router: router)
        let viewController = ProfileViewController()
        
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
