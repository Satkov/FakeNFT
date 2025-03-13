protocol ProfileRouterProtocol {
    func openProfileEdit(withUserId userId: String)
    func openMyNft()
}

final class ProfileRouter: ProfileRouterProtocol {
    weak var viewController: ProfileViewController?
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func openProfileEdit(withUserId userId: String) {
        guard let vc = viewController else { return }
        let profileEditVC = ProfileEditRouter.createModule(servicesAssembly: servicesAssembly, userId: userId)
        vc.present(profileEditVC, animated: true, completion: nil)
    }
    
    func openMyNft() {
        guard let vc = viewController else { return }
        let myNftVC = MyNftRouter.createModule()
        vc.navigationController?.pushViewController(myNftVC, animated: true)
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
