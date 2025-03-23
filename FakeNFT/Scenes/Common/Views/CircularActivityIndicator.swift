import UIKit
import Kingfisher

final class CircularActivityIndicator: Indicator {
    private let containerView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var view: UIView {
        return containerView
    }
    
    func startAnimatingView() {
        containerView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopAnimatingView() {
        containerView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    init() {
        containerView.frame.size = CGSize(width: 70, height: 70)
        containerView.backgroundColor = .projectBlack.withAlphaComponent(0.6)
        containerView.layer.cornerRadius = 35
        containerView.clipsToBounds = true
        
        activityIndicator.color = .projectWhite
        activityIndicator.hidesWhenStopped = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 25),
            activityIndicator.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
