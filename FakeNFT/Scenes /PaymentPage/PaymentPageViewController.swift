import UIKit

protocol PaymentPageViewProtocol: AnyObject {
}

class PaymentPageViewController: UIViewController {
    // MARK: - Public
    var presenter: PaymentPagePresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension PaymentPageViewController {
    func initialize() {
        view.backgroundColor = .blue
    }
}

// MARK: - PaymentPageViewProtocol
extension PaymentPageViewController: PaymentPageViewProtocol {
}
