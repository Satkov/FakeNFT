protocol CartRouterProtocol {
    func showCartFilters(filterVC: FilterViewController)
}

class CartRouter: CartRouterProtocol {
    weak var viewController: CartViewController?

    func showCartFilters(filterVC: FilterViewController) {
        filterVC.modalPresentationStyle = .overFullScreen
        viewController?.present(filterVC, animated: false)
    }
}
