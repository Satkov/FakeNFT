import UIKit
import Kingfisher

final class UserPicView: UIImageView {
    
    private let overlayView: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = .projectBlack.withAlphaComponent(0.6)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        return overlayView
    }()

    private let changePhotoLabel:UILabel = {
        let label = UILabel()
        label.textColor = .whiteUniversal
        label.font = .sfProMedium10
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) { nil }
    
    var isEditable: Bool = false {
        didSet {
            changedEditMode()
        }
    }
    
    override var image: UIImage? {
        didSet {
            changedEditMode()
        }
    }
    
    private func changedEditMode() {
        if isEditable { changePhotoLabel.text = image == nil ? "Добавить\nфото" : "Сменить\nфото" }
        overlayView.isHidden = !isEditable
        changePhotoLabel.isHidden = !isEditable
    }
}

extension UserPicView {
    private func initialize() {
        layer.cornerRadius = 35
        layer.masksToBounds = true
        backgroundColor = .lightGray
        contentMode = .scaleAspectFill
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        overlayView.isHidden = true
        changePhotoLabel.isHidden = true
        kf.indicatorType = .custom(indicator: CircularActivityIndicator())
        
        addSubview(overlayView)
        addSubview(changePhotoLabel)
        
        overlayView.constraintEdges(to: self)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 70),
            heightAnchor.constraint(equalToConstant: 70),
            changePhotoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            changePhotoLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

