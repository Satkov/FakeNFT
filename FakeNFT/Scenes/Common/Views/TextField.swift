import Foundation
import UIKit

final class TextField: UITextField {
    
    private let textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    init() {
        super.init(frame: .zero)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        backgroundColor = .lightGray
        tintColor = .projectBlack
        layer.cornerRadius = 12
        clearButtonMode = .whileEditing
        font = .sfRegular17
        heightAnchor.constraint(equalToConstant: 46).isActive = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.placeholderRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
