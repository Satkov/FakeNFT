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
    }
}

// MARK: - Private functions
private extension ProfileViewController {
    func initialize() {
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
        presenter?.viewDidLoad()
    }
    
    private func setupNavBar() {
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
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

    func showProfile(_ profile: Profile) {
        avatarImage.loadImage(urlString: profile.avatar, defaultImage: UIImage(systemName: "person.crop.circle"))
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
