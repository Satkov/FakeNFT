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
        tableView.register(CartTableViewCell.self)
        tableView.separatorStyle = .none
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
        setupNavBar()
        setupTableView()
        setupConstraints()
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
}
