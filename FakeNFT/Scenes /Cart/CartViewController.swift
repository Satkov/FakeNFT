import UIKit

protocol CartViewProtocol: AnyObject {
    func fillPaymentBlockView(totalPrice: String, numberOfItems: String)
    func displayTable()
}

class CartViewController: UIViewController {
    // MARK: - Public
    var presenter: CartPresenterProtocol?

    // MARK: - Private
    private let servicesAssembly: ServicesAssembly
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()

    private let paymentBlockView = PaymentBlockView()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    private func initialize() {
        setupNavBar()
        setupTableView()
        setupConstraints()
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.isHidden = true
    }
}

// MARK: - Private functions
private extension CartViewController {
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
        let buttons = [
            FilterMenuButtonModel(title: "По цене", action: { print("По цене") }),
            FilterMenuButtonModel(title: "По рейтингу", action: { print("По рейтингу") }),
            FilterMenuButtonModel(title: "По названию", action: { print("По названию") })
        ]
        let vc = FilterViewController(buttons: buttons)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
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
        tableView.reloadData()
    }

}
