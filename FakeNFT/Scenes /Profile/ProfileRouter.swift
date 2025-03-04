//
//  ProfileRouter.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 24.02.2025
//

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
        let profileEditVC = ProfileEditModuleBuilder().createProfileEditModule(servicesAssembly: servicesAssembly, userId: userId)
        vc.present(profileEditVC, animated: true, completion: nil)
    }
    
    func openMyNft() {
        guard let vc = viewController else { return }
        let myNftVC = MyNftModuleBuilder.build()
        vc.navigationController?.pushViewController(myNftVC, animated: true)
    }
}
