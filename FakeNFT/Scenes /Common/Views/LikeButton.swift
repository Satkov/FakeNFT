import UIKit

final class LikeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) { nil }
    
    var isLiked: Bool = false {
        didSet {
            checkIsLiked()
        }
    }
    
    private func initialize() {
        setImage(UIImage(systemName: "heart"), for: .normal)
        tintColor = .redUniversal
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 29.63),
            heightAnchor.constraint(equalToConstant: 29.63)
        ])
    }
    
    @objc private func toggleLike() {
        isLiked = !isLiked
        checkIsLiked()
    }
    
    private func checkIsLiked() {
        let imageName = isLiked ? "heart.fill" : "heart"
        setImage(UIImage(systemName: imageName), for: .normal)
    }
}
