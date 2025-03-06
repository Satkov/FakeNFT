import Foundation
import UIKit

final class ListItem: UIButton {
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(title: "")
    }
    
    private func setupButton(title: String) {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .bodyBold
        self.setTitleColor(.projectBlack, for: .normal)
        
        addSubview(arrowImageView)
    
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 54),
            arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    
        self.contentHorizontalAlignment = .left
    }
}
