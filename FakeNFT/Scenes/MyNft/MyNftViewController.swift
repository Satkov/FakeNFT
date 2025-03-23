import UIKit
import ProgressHUD

protocol MyNftViewProtocol: AnyObject {
    func showNFTs(_ nfts: [MyNft])
    func showError(_ message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

final class MyNftViewController: UIViewController {
    var presenter: MyNftPresenterProtocol?
    
    private let tableView = UITableView()
    
    private let emptyTableLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProBold17
        label.textColor = .projectBlack
        label.textAlignment = .center
        label.text = Localization.noMyNft
        return label
    }()
    private var sortButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoad()
    }
    
    // MARK: - User Actions
    @objc private func didTapSortButton() {
        let alertController = UIAlertController(title: Localization.sort, message: nil, preferredStyle: .actionSheet)
        
        for sortOption in MyNftSortOption.allCases {
            let action = UIAlertAction(title: sortOption.title, style: .default) { [weak self] _ in
                self?.presenter?.didChangeSortOption(sortOption)
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: Localization.close, style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - Private functions
private extension MyNftViewController {
    private func initialize() {
        view.backgroundColor = .projectWhite
        navigationItem.title = Localization.myNft
        
        setupTableView()
        setupSortControl()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyNftTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSortControl() {
        self.sortButton = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )
        navigationController?.navigationBar.tintColor = .projectBlack
    }
    
    private func updateBackgroundViewIfNeeded() {
        if presenter?.nftList.isEmpty ?? true {
            tableView.backgroundView = emptyTableLabel
            navigationItem.rightBarButtonItem = nil
        } else {
            tableView.backgroundView = nil
            navigationItem.rightBarButtonItem = sortButton
        }
    }
}

// MARK: - MyNftViewProtocol
extension MyNftViewController: MyNftViewProtocol {
    func showNFTs(_ nfts: [MyNft]) {
        updateBackgroundViewIfNeeded()
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        LoaderUtil.hide()
        AlertUtil.show(error: message, in: self)
    }
    
    func showLoadingIndicator() {
        LoaderUtil.show()
    }
    
    func hideLoadingIndicator() {
        LoaderUtil.hide()
    }
}

// MARK: - UITableView DataSource & Delegate
extension MyNftViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.nftList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNftTableViewCell = tableView.dequeueReusableCell()
        if let nftPresenter = presenter {
            let nft = nftPresenter.nftList[indexPath.row]
            cell.onLikeButtonTapped = { [weak self] nft in
                self?.presenter?.didToggleLike(at: indexPath.row)
            }
            cell.configure(with: nft)
        }
        return cell
    }
}
