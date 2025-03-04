//
//  ProfileEditRouterProtocol.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 01.03.2025.
//

import UIKit

protocol ProfileEditRouterProtocol: AnyObject {
    func closeProfileEdit()
    func openImagePicker()
}

final class ProfileEditRouter: ProfileEditRouterProtocol {
    weak var viewController: UIViewController?
    
    func closeProfileEdit() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func openImagePicker() {
        guard let vc = viewController else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = vc as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        vc.present(imagePicker, animated: true, completion: nil)
    }
}
