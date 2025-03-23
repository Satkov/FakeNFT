import UIKit

protocol ProfileEditRouterProtocol: AnyObject {
    func closeProfileEdit()
}

final class ProfileEditRouter: ProfileEditRouterProtocol {
    weak var viewController: UIViewController?
    
    func closeProfileEdit() {
        viewController?.dismiss(animated: true)
    }

    static func createModule(servicesAssembly: ServicesAssembly, userId: String, onProfileUpdated callback: @escaping (Profile) -> Void) -> UIViewController {
        let view = ProfileEditViewController()
        let router = ProfileEditRouter()
        let interactor = ProfileEditInteractor(profileService: servicesAssembly.profileService)
        let presenter = ProfileEditPresenter(interactor: interactor, router: router)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.onProfileUpdated = callback
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
