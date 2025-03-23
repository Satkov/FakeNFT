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
        setImage(UIImage(systemName: "heart.fill"), for: .normal)
        tintColor = .redUniversal
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 29.63),
            heightAnchor.constraint(equalToConstant: 29.63)
        ])
    }
    
    private func checkIsLiked() {
        tintColor = isLiked ? .redUniversal : .whiteUniversal
    }
}
