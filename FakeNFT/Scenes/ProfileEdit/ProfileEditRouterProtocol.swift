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
    
    static func createModule(servicesAssembly: ServicesAssembly, userId: String) -> UIViewController {
        let view = ProfileEditViewController()
        let presenter = ProfileEditPresenter()
        let router = ProfileEditRouter()
        let interactor = ProfileEditInteractor(profileService: servicesAssembly.profileService)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
