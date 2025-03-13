//
//  UserPicView.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 13.03.2025.
//


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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var editable: Bool = false {
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
        if editable {
            overlayView.isHidden = false
            changePhotoLabel.isHidden = false
            changePhotoLabel.text = image == nil ? "Добавить\nфото" : "Сменить\nфото"
        } else {
            overlayView.isHidden = true
            changePhotoLabel.isHidden = true
        }
    }
}

extension UserPicView {
    func initialize() {
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
