import UIKit

protocol ProfileEditRouterProtocol: AnyObject {
    func closeProfileEdit()
    func openImagePicker()
}

final class ProfileEditRouter: ProfileEditRouterProtocol {
    weak var viewController: UIViewController?
    
    func closeProfileEdit() {
        viewController?.dismiss(animated: true)
    }
    
    func openImagePicker() {
        guard let vc = viewController else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = vc as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        vc.present(imagePicker, animated: true, completion: nil)
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
