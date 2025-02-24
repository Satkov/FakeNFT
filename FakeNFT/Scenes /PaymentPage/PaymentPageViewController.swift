import UIKit

protocol PaymentPageViewProtocol: AnyObject {
}

class PaymentPageViewController: UIViewController {
    // MARK: - Public
    var presenter: PaymentPagePresenterProtocol?

    private let currencyCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension PaymentPageViewController {
    func initialize() {
        setupNavBar()
    }

    func setupNavBar() {
        let filterButton = UIBarButtonItem(
            image: UIImage(named: "filterIcon"),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        filterButton.tintColor = UIColor.projectBlack
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.title = "Выберите способ оплаты"
    }

    @objc
    func filterButtonTapped() {
    }
}

// MARK: - PaymentPageViewProtocol
extension PaymentPageViewController: PaymentPageViewProtocol {
}
