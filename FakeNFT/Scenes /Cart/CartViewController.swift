import UIKit

// MARK: - Protocol
protocol CartViewProtocol: AnyObject {
    func showNfts(totalPrice: String, numberOfItems: String)
    func reloadTable()
    func showLoader()
    func hideLoader()
}

// MARK: - CartViewController
final class CartViewController: UIViewController {

    // MARK: - Public Properties
    var presenter: CartPresenterProtocol?

    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.isHidden = true
        return tableView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let paymentBlockView = PaymentBlockView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private Methods
private extension CartViewController {
    func setupUI() {
        setupNavBar()
        setupTableView()
        setupActivityIndicator()
        setupConstraints()
        navigationController?.setNavigationBarHidden(true, animated: false)
        paymentBlockView.isHidden = true
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
    }

    func setupTableView() {
        tableView.delegate = presenter
        tableView.dataSource = presenter
    }

    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraints() {
        [tableView, paymentBlockView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -76),

            paymentBlockView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            paymentBlockView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentBlockView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentBlockView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc
    func filterButtonTapped() {
        presenter?.showFilters()
    }
}

// MARK: - CartViewProtocol
extension CartViewController: CartViewProtocol {

    func showNfts(totalPrice: String, numberOfItems: String) {
        paymentBlockView.configurate(
            totalPrice: totalPrice,
            numberOfItems: numberOfItems
        ) { [weak self] in
            self?.presenter?.showPayment()
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.isHidden = false
        paymentBlockView.isHidden = false
    }

    func reloadTable() {
        tableView.reloadData()
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
}
