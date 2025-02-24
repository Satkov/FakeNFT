import UIKit

protocol StatisticViewProtocol: AnyObject {
    func reloadData()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

class StatisticViewController: UIViewController, StatisticViewProtocol {
    
    var presenter: StatisticPresenterProtocol?

    private let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sortButton"), for: .normal)
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    init(presenter: StatisticPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        presenter?.viewDidLoad()
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }

    private func initialize() {
        setupTableView()
        setupConstraints()
    }

    private func setupTableView() {
        tableView.delegate = presenter
        tableView.dataSource = presenter
        tableView.register(StatisticCell.self, forCellReuseIdentifier: "StatisticCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }

    private func setupConstraints() {
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sortButton)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }

    func reloadData() {
        tableView.reloadData()
    }
    
    @objc private func sortButtonTapped() {
        
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: SortOption.byName.rawValue, style: .default, handler: { _ in
            self.presenter?.sortUsers(by: .byName)
        }))
        
        alert.addAction(UIAlertAction(title: SortOption.byRank.rawValue, style: .default, handler: { _ in
            self.presenter?.sortUsers(by: .byRank)
        }))
    
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        present(alert, animated: true)
    }
}
