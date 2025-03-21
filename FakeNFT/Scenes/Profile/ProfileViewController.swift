import UIKit
import ProgressHUD
import Kingfisher

protocol ProfileViewProtocol: AnyObject {
    func showProfile(_ profile: Profile)
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let websiteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .sfRegular15
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let myNftButton = ListItem(title: "Мои NFT")
    
    private let likedNftButton = ListItem(title: "Избранные NFT")
    
    private let aboutDevButton = ListItem(title: "О разработчике")
    
    private let avatarAndNameStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
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
        
        avatarAndNameStack.addArrangedSubview(avatarImage)
        avatarAndNameStack.addArrangedSubview(nameLabel)
        buttonsStack.addArrangedSubview(myNftButton)
        buttonsStack.addArrangedSubview(likedNftButton)
        buttonsStack.addArrangedSubview(aboutDevButton)
        view.addSubview(avatarAndNameStack)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(buttonsStack)
        
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
    func showLoading() {
        ProgressHUD.show("Загрузка...", interaction: false)
    }

    func hideLoading() {
        ProgressHUD.dismiss()
    }

    func showProfile(_ profile: Profile) {
        avatarImage.loadImage(urlString: profile.avatar, defaultImage: UIImage(named: "avatar"))
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteButton.setTitle(profile.website, for: .normal)
        myNftButton.setTitle("Мои NFT (\(profile.nfts.count))", for: .normal)
        likedNftButton.setTitle("Избранные NFT (\(profile.likes.count))", for: .normal)
    }

    func showError(_ message: String) {
        ProgressHUD.dismiss()
    
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
