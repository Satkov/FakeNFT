//
//  NFTCollectionListViewController.swift
//  Super easy dev
//
//  Created by Nikolay on 16.02.2025
//

import UIKit

protocol NFTCollectionListViewProtocol: AnyObject {
    func nftCollectionListDidLoad()
    func nftCollectionListLoadError(error: Error)
}

final class NFTCollectionListViewController: UIViewController {
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
        presenter?.loadNFTCollectionList()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        
    }
}

// MARK: - NFTCollectionListViewProtocol
extension NFTCollectionListViewController: NFTCollectionListViewProtocol {
    func nftCollectionListDidLoad() {
        collectionView.reloadData()
    }
    
    func nftCollectionListLoadError(error: Error) {
        print(error)
    }
}
