import UIKit
import ProgressHUD
import Kingfisher

protocol ProfileViewProtocol: AnyObject {
    func showProfile(_ profile: Profile)
    func showError(_ message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

final class ProfileViewController: UIViewController {
    // MARK: - Public
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Private
    private let avatarImage = UserPicView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProBold22
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .sfRegular13
        label.numberOfLines = 4
        return label
    }()
    
    private let websiteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .sfRegular15
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let myNftButton = ListItem(title: Localization.profileMyNft)
    
    private let likedNftButton = ListItem(title: Localization.profileFavouriteNft)
    
    private let aboutDevButton = ListItem(title: Localization.profileAboutDeveloper)
    
    private let avatarAndNameStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        return stack
    }()
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidApear()
    }
}

// MARK: - Private functions
private extension ProfileViewController {
    private func initialize() {
        view.backgroundColor = .projectWhite
        setupNavBar()
        
        [avatarImage,
         nameLabel].forEach {
            avatarAndNameStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [myNftButton,
         likedNftButton,
         aboutDevButton].forEach { buttonsStack.addArrangedSubview($0) }
        
        [avatarAndNameStack,
         descriptionLabel,
         websiteButton,
         buttonsStack].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
        
        myNftButton.addTarget(self, action: #selector(didTapMyNftButton), for: .touchUpInside)
        likedNftButton.addTarget(self, action: #selector(didTapLikedNftButton), for: .touchUpInside)
        aboutDevButton.addTarget(self, action: #selector(didTapAboutDevButton), for: .touchUpInside)
    }
    
    private func setupNavBar() {
        let editButton = UIBarButtonItem(
            image: UIImage(named: "Edit"),
            style: .plain,
            target: self,
            action: #selector(didTapEditButton)
        )
        navigationController?.navigationBar.tintColor = .projectBlack
        navigationItem.rightBarButtonItem = editButton
        navigationItem.backButtonTitle = ""
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarAndNameStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarAndNameStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarAndNameStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
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
    }
    
    // MARK: - Action
    @objc private func didTapEditButton() {
        presenter?.didTapEditButton()
    }
    
    @objc private func didTapMyNftButton() {
        presenter?.didTapMyNftButton()
    }
    
    @objc private func didTapLikedNftButton() {
        presenter?.didTapLikedNftButton()
    }
    
    @objc private func didTapAboutDevButton() {
        presenter?.didTapAboutDevButton()
    }
}

// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func showLoadingIndicator() {
        LoaderUtil.show()
    }
    
    func hideLoadingIndicator() {
        LoaderUtil.hide()
    }
    
    func showProfile(_ profile: Profile) {
        avatarImage.loadImage(urlString: profile.avatar, defaultImage: UIImage(named: "avatar"))
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteButton.setTitle(profile.website, for: .normal)
        myNftButton.setTitle("\(Localization.profileMyNft) (\(profile.nfts.count))", for: .normal)
        likedNftButton.setTitle("\(Localization.profileFavouriteNft) (\(profile.likes.count))", for: .normal)
    }
    
    func showError(_ message: String) {
        LoaderUtil.hide()
        AlertUtil.show(error: message, in: self)
    }
}
