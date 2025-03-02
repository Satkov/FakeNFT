protocol PaymentPageRouterProtocol {
    func showWebView()
    func showSuccessPaymentView()
}

class PaymentPageRouter: PaymentPageRouterProtocol {
    weak var viewController: PaymentPageViewController?

    func showWebView() {
        let webVC = WebViewViewController(url: "https://practicum.yandex.ru/")
        webVC.modalPresentationStyle = .pageSheet
        viewController?.present(webVC, animated: true)
    }

    func showSuccessPaymentView() {
        let successVC = SuccessPaymentViewController()
        successVC.modalPresentationStyle = .overFullScreen
        viewController?.present(successVC, animated: true)
    }
}
