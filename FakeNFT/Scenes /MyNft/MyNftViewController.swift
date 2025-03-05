//
//  MyNftViewController.swift
//  Super easy dev
//
//  Created by Alibi Mailan on 03.03.2025
//

import UIKit

protocol MyNftViewProtocol: AnyObject {
    func showNFTs(_ nfts: [Nft])
    func showError(_ message: String)
    func endRefreshing()
}

class MyNftViewController: UIViewController {
    var presenter: MyNftPresenterProtocol?
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let emptyTableLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .projectBlack
        label.textAlignment = .center
        label.text = "У Вас ещё нет NFT"
        return label
    }()
    private var sortButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - User Actions
    @objc private func didPullToRefresh() {
        presenter?.didPullToRefresh()
    }
    
    @objc private func didTapSortButton() {
    }
}

// MARK: - Private functions
private extension MyNftViewController {
    func initialize() {
        view.backgroundColor = .projectWhite
        navigationItem.title = Localization.myNft
        
        setupTableView()
        setupSortControl()
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        updateBackgroundViewIfNeeded()
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.register(MyNftTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
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
    func showNFTs(_ nfts: [Nft]) {
        updateBackgroundViewIfNeeded()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        refreshControl.endRefreshing()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
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
            cell.configure(with: nft)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectNFT(at: indexPath.row)
    }
}
