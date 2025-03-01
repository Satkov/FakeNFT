import UIKit

protocol PaymentPageViewProtocol: AnyObject {
}

class PaymentPageViewController: UIViewController {
    // MARK: - Public
    var presenter: PaymentPagePresenterProtocol?

    private let agreementAndPayView = AgreementAndPayView()
    private let currencyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.projectWhite
        collectionView.layer.cornerRadius = 12

        return collectionView
    }()

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
        setupCurrencyCollectionView()
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

    func setupCurrencyCollectionView() {
        currencyCollectionView.register(PaymentMethodCollectionViewCell.self)
        currencyCollectionView.dataSource = presenter
        currencyCollectionView.delegate = presenter
    }

    func setupConstraints() {
        agreementAndPayView.translatesAutoresizingMaskIntoConstraints = false
        currencyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(agreementAndPayView)
        view.addSubview(currencyCollectionView)

        NSLayoutConstraint.activate([
            agreementAndPayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            agreementAndPayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            agreementAndPayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            agreementAndPayView.heightAnchor.constraint(equalToConstant: 186),

            currencyCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currencyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currencyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currencyCollectionView.bottomAnchor.constraint(equalTo: agreementAndPayView.topAnchor)
        ])

        if let layout = currencyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let columns: CGFloat = 2
            let totalSpacing: CGFloat = 7 * (columns - 1) + 16 * 2
            let itemWidth = (view.frame.width - totalSpacing) / columns
            layout.itemSize = CGSize(width: itemWidth, height: 46)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }

    @objc
    func filterButtonTapped() {
    }
}

// MARK: - PaymentPageViewProtocol
extension PaymentPageViewController: PaymentPageViewProtocol {
}
