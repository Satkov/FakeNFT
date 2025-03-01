protocol CartRouterProtocol {
    func showCartFilters(filterVC: FilterViewController)
    func showPaymentPage()
    func showDeletePage(imageUrlString: String, deleteAction: @escaping (() -> Void))
}

final class CartRouter: CartRouterProtocol {
    weak var viewController: CartViewController?
    private let servicesAssembly: ServicesAssembly

    init(
        serviceAssembly: ServicesAssembly
    ) {
        self.servicesAssembly = serviceAssembly
    }

    func showCartFilters(filterVC: FilterViewController) {
        filterVC.modalPresentationStyle = .overFullScreen
        viewController?.present(filterVC, animated: false)
    }

    func showPaymentPage() {
        let paymentVC = PaymentPageModuleFactory.build(servicesAssembly: servicesAssembly)
        paymentVC.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(paymentVC, animated: true)
    }

    func showDeletePage(imageUrlString: String, deleteAction: @escaping (() -> Void)) {
        let deleteNftVC = DeleteNftFromCartViewController()
        deleteNftVC.configure(
            imageUrlString: imageUrlString,
            deleteAction: deleteAction
        )
        deleteNftVC.modalPresentationStyle = .overFullScreen
        deleteNftVC.modalTransitionStyle = .crossDissolve
        viewController?.present(deleteNftVC, animated: true)
    }
}
