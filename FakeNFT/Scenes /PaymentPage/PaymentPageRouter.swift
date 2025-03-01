protocol PaymentPageRouterProtocol {
    func showWebView()
}

class PaymentPageRouter: PaymentPageRouterProtocol {
    weak var viewController: PaymentPageViewController?

    func showWebView() {
        let webVC = WebViewViewController(url: "https://practicum.yandex.ru/")
        webVC.modalPresentationStyle = .pageSheet
        viewController?.present(webVC, animated: true)
    }
}
