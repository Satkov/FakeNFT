import UIKit
import ProgressHUD

protocol ProfileEditViewProtocol: AnyObject {
    var nameText: String { get }
    var descriptionText: String { get }
    var websiteText: String { get }
    
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
    
    private let profileImageView = UserPicView()
    
    private let nameHeader = FieldHeader(text: Localization.name)
    private let nameTextField = TextField()
    
    private let descriptionHeader = FieldHeader(text: Localization.description)
    private let descriptionTextView = TextView(maxLinesCount: 5)
    
    private let websiteHeader = FieldHeader(text: Localization.website)
    private let websiteTextField = TextField()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.didTapSave()
    }
    
    // MARK: - Actions
    @objc private func didTapClose() {
        presenter?.didTapClose()
    }
}

extension ProfileEditViewController {
    private func initialize() {
        view.backgroundColor = .projectWhite
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
        
        setupConstraints()
        
        profileImageView.isEditable = true
        profileImageView.delegate = self
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
        
        descriptionTextView.delegate = self
        descriptionTextView.returnKeyType = .done
        
        websiteTextField.delegate = self
        websiteTextField.returnKeyType = .done
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            
            profileImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            profileImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
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

// MARK: - ProfileEditViewProtocol
extension ProfileEditViewController: ProfileEditViewProtocol {
    var nameText: String { nameTextField.text ?? "" }
    var descriptionText: String { descriptionTextView.text ?? "" }
    var websiteText: String { websiteTextField.text ?? "" }
    
    func showProfileData(_ profile: Profile) {
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        websiteTextField.text = profile.website
        profileImageView.loadImage(urlString: profile.avatar, defaultImage: UIImage(named: "avatar"))
    }
    
    func showLoadingIndicator() {
        LoaderUtil.show()
    }
    
    func hideLoadingIndicator() {
        LoaderUtil.hide()
    }
    
    func showError(_ message: String) {
        hideLoadingIndicator()
        AlertUtil.show(error: message, in: self)
    }
}

// MARK: - UITextFieldDelegate
extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension ProfileEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: - UserPicViewDelegate
extension ProfileEditViewController: UserPicViewDelegate {
    func userPicViewDidTapChangePhoto(_ userPicView: UserPicView) {
        let alertController = UIAlertController(title: Localization.changeAvatar, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "URL"
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if let textField = alertController.textFields?.first,
            let avatarUrl = textField.text {
                self?.presenter?.didUpdate(avatarUrl: avatarUrl)
            }
        }
        alertController.addAction(okAction)
                
        let removeAction = UIAlertAction(title: Localization.delete, style: .destructive) { [weak self] action in
            self?.presenter?.didRemoveAvatar()
        }
        alertController.addAction(removeAction)
                
        let cancelAction = UIAlertAction(title: Localization.close, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
                
        self.present(alertController, animated: true, completion: nil)
    }
}
