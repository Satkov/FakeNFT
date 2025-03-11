import UIKit
import ProgressHUD

protocol ProfileEditViewProtocol: AnyObject {
    func showProfileData(_ profile: Profile)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(_ message: String)
}

final class ProfileEditViewController: UIViewController {
    
    var presenter: ProfileEditPresenterProtocol?
    
    private let contentView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 24
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let headerView = UIView()
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .projectBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameHeader = FieldHeader(text: Localization.name)
    private let nameTextField = TextField()
    
    private let descriptionHeader = FieldHeader(text: Localization.description)
    private let descriptionTextView = TextView(maxLinesCount: 5)
    
    private let websiteHeader = FieldHeader(text: Localization.website)
    private let websiteTextField = TextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Actions
    @objc private func didTapClose() {
        presenter?.didTapClose()
    }
    
    @objc private func photoTapped() {
        presenter?.didTapChangePhoto()
    }
}

extension ProfileEditViewController {
    private func initialize() {
        view.backgroundColor = .projectWhite
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(closeButton)
        headerView.addSubview(profileImageView)
        
        view.addSubview(contentView)
        
        [headerView,
         fieldStackView(label: nameHeader, field: nameTextField),
         fieldStackView(label: descriptionHeader, field: descriptionTextView),
         fieldStackView(label: websiteHeader, field: websiteTextField)
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addArrangedSubview($0)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        setupConstraints()
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        presenter?.viewDidLoad()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            
            profileImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            profileImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            contentView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132)
        ])
    }
    
    private func fieldStackView(label: UIView, field: UIView) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(field)
        return stackView
    }
}

extension ProfileEditViewController: ProfileEditViewProtocol {
    func showProfileData(_ profile: Profile) {
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        websiteTextField.text = profile.website
        profileImageView.loadImage(urlString: profile.avatar, defaultImage: UIImage(systemName: "person.crop.circle"))
    }
    
    func showLoadingIndicator() {
        ProgressHUD.show("Загрузка...")
    }
    
    func hideLoadingIndicator() {
        ProgressHUD.dismiss()
    }
    
    func showError(_ message: String) {
        hideLoadingIndicator()
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
