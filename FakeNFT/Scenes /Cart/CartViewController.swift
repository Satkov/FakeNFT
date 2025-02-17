import UIKit

protocol CartViewProtocol: AnyObject {
}

class CartViewController: UIViewController {
    // MARK: - Public
    var presenter: CartPresenterProtocol?

    // MARK: - Private
    private let servicesAssembly: ServicesAssembly
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    private let paymentBlockView: PaymentBlockView = {
        let view = PaymentBlockView()
        view.configurate()
        return view
    }()

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
}

// MARK: - Private functions
private extension CartViewController {
    func initialize() {
        setupTableView()

        setupConstraints()
    }

    func setupTableView() {
        tableView.delegate = presenter
        tableView.dataSource = presenter
        tableView.backgroundColor = .blue
    }

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        paymentBlockView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(paymentBlockView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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


}

// MARK: - CartViewControllerViewProtocol
extension CartViewController: CartViewProtocol {
}
