//
//  NFTCollectionDetailViewController.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

import UIKit
import Kingfisher

protocol NFTCollectionDetailViewProtocol: AnyObject {
    func updateNftCollectionInformation(name: String, imageURL: URL?, description: String, authorName: String)
    func showError(error: Error)
    func updateNftList()
}

final class NFTCollectionDetailViewController: UIViewController, ErrorView, LoadingView {
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var nftCollectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nftCollectionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Bold", size: 22)
        label.textColor = UIColor.textPrimary
        return label
    }()
    
    private lazy var nftCollectionAuthorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nftCollectionAuthorTitleLabel)
        stackView.addArrangedSubview(nftCollectionAuthorNameLabel)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var nftCollectionAuthorTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = UIFont(name: "SF Pro Regular", size: 13)
        label.textColor = UIColor.textPrimary
        label.text = "Автор коллекции: "
        label.textAlignment = .left
        return label
    }()
    
    private lazy var nftCollectionAuthorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.font = UIFont(name: "SF Pro Regular", size: 15)
        label.textColor = UIColor.linkText
        label.textAlignment = .left
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onClickLabel))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gestureRecognizer)
        return label
    }()
    
    private lazy var nftCollectionDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Regular", size: 13)
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nftsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NFTCollectionViewCell.self)
        return collectionView
    }()
    
    @objc private func onClickLabel(sender: UITapGestureRecognizer) {
        presenter?.showAuthorPage()
    }
    
    // MARK: - Public Properties
    var presenter: NFTCollectionDetailPresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        presenter?.loadCurrentNFTCollection()
        presenter?.loadProfile()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var corners: UIRectCorner = []
        corners.update(with: .bottomLeft)
        corners.update(with: .bottomRight)
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: nftCollectionImageView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 12, height: 12)).cgPath
        nftCollectionImageView.layer.mask = maskLayer
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        
        view.addSubview(nftCollectionImageView)
        view.addSubview(nftCollectionNameLabel)
        //view.addSubview(nftCollectionAuthorTitleLabel)
        view.addSubview(nftCollectionDescription)
        view.addSubview(nftCollectionAuthorStackView)
        view.addSubview(nftsCollectionView)
        view.addSubview(activityIndicator)
        navigationItem.backButtonTitle = ""
        
        NSLayoutConstraint.activate([
            nftCollectionImageView.topAnchor.constraint(equalTo: view.topAnchor),
            nftCollectionImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollectionImageView.heightAnchor.constraint(equalToConstant: 310),
            nftCollectionNameLabel.topAnchor.constraint(equalTo: nftCollectionImageView.bottomAnchor, constant: 16),
            nftCollectionNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionNameLabel.heightAnchor.constraint(equalToConstant: 28),
            nftCollectionAuthorStackView.topAnchor.constraint(equalTo: nftCollectionNameLabel.bottomAnchor, constant: 13),
            nftCollectionAuthorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionAuthorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionAuthorStackView.heightAnchor.constraint(equalToConstant: 20),
            nftCollectionDescription.topAnchor.constraint(equalTo: nftCollectionAuthorStackView.bottomAnchor, constant: 5),
            nftCollectionDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nftsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nftsCollectionView.topAnchor.constraint(equalTo: nftCollectionDescription.bottomAnchor, constant: 24),
            nftsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - NFTCollectionDetailViewProtocol
extension NFTCollectionDetailViewController: NFTCollectionDetailViewProtocol {
    
    func updateNftCollectionInformation(name: String, imageURL: URL?, description: String, authorName: String) {
        nftCollectionNameLabel.text = name
        nftCollectionImageView.kf.indicatorType = .activity
        nftCollectionImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "Placeholder"))
        nftCollectionDescription.text = description
        nftCollectionAuthorNameLabel.text = authorName
    }
    
    func showError(error: Error) {
        hideLoading()
        let errorModel = ErrorModel(message: error.localizedDescription, actionText: "OK", action: {})
        showError(errorModel)
    }
    
    func updateNftList() {
        hideLoading()
        nftsCollectionView.reloadData()
    }
}

extension NFTCollectionDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return presenter?.nftCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: NFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
        if let businessObject = presenter?.nftBusinessObject(index: indexPath) {
            cell.configure(businessObject: businessObject)
        }
        return cell
    }
}

extension NFTCollectionDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 108, height: 192)
    }
}
