protocol CartRouterProtocol {
    func showCartFilters(filterVC: FilterViewController)
    func showPaymentPage()
}

final class CartRouter: CartRouterProtocol {
    weak var viewController: CartViewController?

    func showCartFilters(filterVC: FilterViewController) {
        filterVC.modalPresentationStyle = .overFullScreen
        viewController?.present(filterVC, animated: false)
    }

    func showPaymentPage() {
        let paymentVC = PaymentPageModuleBuilder.build()
        viewController?.navigationController?.pushViewController(paymentVC, animated: true)
    }
}
