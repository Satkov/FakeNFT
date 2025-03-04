//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 24.02.2025
//

import UIKit
import ProgressHUD
import Kingfisher

protocol ProfileViewProtocol: AnyObject {
    func showProfile(_ profile: ProfileEntity)
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
}

final class ProfileViewController: UIViewController {
    // MARK: - Public
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Private
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let websiteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.caption1
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let myNftButton = ListItem(title: "Мои NFT")
    private let likedNftButton = ListItem(title: "Избранные NFT")
    private let aboutDevButton = ListItem(title: "О разработчике")

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension ProfileViewController {
    func initialize() {
        view.backgroundColor = .projectWhite
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(didTapEditButton)
        )
        navigationController?.navigationBar.tintColor = .projectBlack
        navigationItem.rightBarButtonItem = editButton
        navigationItem.backButtonTitle = ""
        
        let avatarAndNameStack = UIStackView()
        avatarAndNameStack.spacing = 16
        avatarAndNameStack.translatesAutoresizingMaskIntoConstraints = false
        avatarAndNameStack.addArrangedSubview(avatarImage)
        avatarAndNameStack.addArrangedSubview(nameLabel)

        let buttonsStack = UIStackView()
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.distribution = .fill
        buttonsStack.axis = .vertical
        buttonsStack.addArrangedSubview(myNftButton)
        buttonsStack.addArrangedSubview(likedNftButton)
        buttonsStack.addArrangedSubview(aboutDevButton)
        
        view.addSubview(avatarAndNameStack)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            avatarAndNameStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarAndNameStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarAndNameStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarAndNameStack.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            buttonsStack.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 40),
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])

        myNftButton.addTarget(self, action: #selector(didTapMyNftButton), for: .touchUpInside)
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Action
    @objc private func didTapEditButton() {
        presenter?.didTapEditButton()
    }
    
    @objc private func didTapMyNftButton() {
        presenter?.didTapMyNftButton()
    }
}

// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func showLoading() {
        ProgressHUD.show("Загрузка...")
    }

    func hideLoading() {
        ProgressHUD.dismiss()
    }

    func showProfile(_ profile: ProfileEntity) {
        avatarImage.loadImage(urlString: profile.avatarURL, defaultImage: UIImage(systemName: "person.crop.circle"))
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteButton.setTitle(profile.website, for: .normal)
    }

    func showError(_ message: String) {
        ProgressHUD.dismiss()
    
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
