import UIKit

protocol PaymentPageViewProtocol: AnyObject {
    func showCollection()
    func showLoader()
    func hideLoader()
    func reloadCollection()
}

class PaymentPageViewController: UIViewController {
    // MARK: - Public
    var presenter: PaymentPagePresenterProtocol?

    private lazy var agreementAndPayView = AgreementAndPayView()
    private lazy var currencyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.projectWhite
        collectionView.layer.cornerRadius = 12
        collectionView.isHidden = true

        return collectionView
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
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
        view.backgroundColor = UIColor.projectWhite
        navigationItem.title = Localization.paymentPageTitle
        agreementAndPayView.presenter = presenter
        setupConstraints()
        setupCurrencyCollectionView()
    }

    func setupCurrencyCollectionView() {
        currencyCollectionView.register(PaymentMethodCollectionViewCell.self)
        currencyCollectionView.dataSource = presenter
        currencyCollectionView.delegate = presenter
    }

    func setupConstraints() {
        [agreementAndPayView,
         activityIndicator,
         currencyCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            agreementAndPayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            agreementAndPayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            agreementAndPayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            agreementAndPayView.heightAnchor.constraint(equalToConstant: 186),

            currencyCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currencyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currencyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currencyCollectionView.bottomAnchor.constraint(equalTo: agreementAndPayView.topAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: currencyCollectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: currencyCollectionView.centerYAnchor)
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
    func showCollection() {
        currencyCollectionView.isHidden = false
        currencyCollectionView.reloadData()
    }

    func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.view.bringSubviewToFront(self.activityIndicator)
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }

    func reloadCollection() {
        currencyCollectionView.reloadData()
    }
}
