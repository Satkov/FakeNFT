import UIKit

final class TextView: UITextView {
    
    private let textPadding = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
    
    init(maxLinesCount: Int) {
        super.init(frame: .zero, textContainer: nil)
        setupTextView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextView()
    }
    
    private func setupTextView() {
        backgroundColor = .lightGray
        tintColor = .projectBlack
        layer.cornerRadius = 12
        font = .bodyRegular
        isScrollEnabled = true
        textContainer.lineBreakMode = .byWordWrapping
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = textPadding
    }
}
