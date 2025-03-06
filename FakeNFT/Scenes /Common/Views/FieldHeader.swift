import UIKit

final class FieldHeader: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        textColor = .projectBlack
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
        font = .headline3
    }
}
