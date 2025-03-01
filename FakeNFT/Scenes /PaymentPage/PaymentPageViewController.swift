import UIKit

protocol PaymentPageViewProtocol: AnyObject {
}

class PaymentPageViewController: UIViewController {
    // MARK: - Public
    var presenter: PaymentPagePresenterProtocol?

    private let agreementAndPayView = AgreementAndPayView()

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
        view.backgroundColor = UIColor.segmentInactive
        agreementAndPayView.presenter = presenter
        setupNavBar()
        setupConstraints()
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

    func setupConstraints() {
        agreementAndPayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(agreementAndPayView)

        NSLayoutConstraint.activate([
            agreementAndPayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            agreementAndPayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            agreementAndPayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            agreementAndPayView.heightAnchor.constraint(equalToConstant: 186)
        ])
    }

    @objc
    func filterButtonTapped() {
    }
}

// MARK: - PaymentPageViewProtocol
extension PaymentPageViewController: PaymentPageViewProtocol {
}
