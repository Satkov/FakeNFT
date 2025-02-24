import UIKit

protocol CartViewProtocol: AnyObject {
    func fillPaymentBlockView(totalPrice: String, numberOfItems: String)
    func displayTable()
    func reloadTable()
    func showLoader()
    func hideLoader()
}

class CartViewController: UIViewController {
    // MARK: - Public
    var presenter: CartPresenterProtocol?

    // MARK: - Private
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.isHidden = true
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let paymentBlockView = PaymentBlockView()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    private func initialize() {
        setupActivityIndicator()
        setupNavBar()
        setupTableView()
        setupConstraints()
        navigationController?.setNavigationBarHidden(true, animated: false)
        paymentBlockView.isHidden = true
    }
}

// MARK: - Private functions
private extension CartViewController {
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "filterIcon"),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = UIColor.projectBlack
    }

    func setupTableView() {
        tableView.delegate = presenter
        tableView.dataSource = presenter
    }

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        paymentBlockView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(paymentBlockView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -76)
        ])

        NSLayoutConstraint.activate([
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

// MARK: - CartViewControllerViewProtocol
extension CartViewController: CartViewProtocol {
    func fillPaymentBlockView(
        totalPrice: String,
        numberOfItems: String) {
        paymentBlockView.configurate(
            totalPrice: totalPrice,
            numberOfItems: numberOfItems
        )
    }

    func displayTable() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.isHidden = false
        paymentBlockView.isHidden = false
        tableView.reloadData()
    }

    func reloadTable() {
        tableView.reloadData()
    }

    func showLoader() {
        print(1)
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
}
