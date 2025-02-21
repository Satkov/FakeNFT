//
//  NFTCollectionListViewController.swift
//  Super easy dev
//
//  Created by Nikolay on 16.02.2025
//

import UIKit

protocol NFTCollectionListViewProtocol: AnyObject {
    func updateForNewData()
    func showError(error: Error)
}

final class NFTCollectionListViewController: UIViewController, ErrorView, LoadingView {
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - IB Outlets
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NFTCollectionListCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Public
    var presenter: NFTCollectionListPresenterProtocol?
    
    // MARK: - Private
    private let cellIdentifier = "trackCellIdentifier"

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        presenter?.loadNFTCollectionList()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "CatalogSortButtonImage"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.navigationBarButton
    }
    
    @objc func sortButtonTapped() {
        
        let nameSortModel = FilterMenuButtonModel(title: "По названию", action: {
            self.presenter?.sortNftCollectionList(type: .name)
        })
        let nftCountSortModel = FilterMenuButtonModel(title: "По количеству NFT", action: {
            self.presenter?.sortNftCollectionList(type: .nftCount)
        })
        let buttons = [nameSortModel, nftCountSortModel]
        let filterViewController = FilterViewController(buttons: buttons)
        filterViewController.modalPresentationStyle = .overFullScreen
        present(filterViewController, animated: false)
    }
}

extension NFTCollectionListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return presenter?.numberOfNFTCollections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: NFTCollectionListCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        if let model = presenter?.cellModelForIndex(indexPath) {
            cell.configure(model: model)
        }
        return cell
    }
}

extension NFTCollectionListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.bounds.size.width - 16 * 2, height: 187)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.showNftCollectionDetailForIndexPath(indexPath)
    }
}

// MARK: - NFTCollectionListViewProtocol
extension NFTCollectionListViewController: NFTCollectionListViewProtocol {
    func updateForNewData() {
        hideLoading()
        collectionView.reloadData()
    }
    
    func showError(error: Error) {
        hideLoading()
        let errorModel = ErrorModel(message: error.localizedDescription, actionText: "OK", action: {})
        showError(errorModel)
    }
}
