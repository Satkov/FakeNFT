//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Nikolay on 03.03.2025.
//

import UIKit

final class NFTCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - IB Outlets
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var nftRatingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Bold", size: 17)
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SF Pro Medium", size: 10)
        label.textColor = UIColor.textPrimary
        return label
    }()
    
    private lazy var orderImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        return image
    }()
    
    private lazy var likeImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        return image
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.cancelDownloadTask()
    }
    
    // MARK: - Public Methods
    func configure(businessObject: NftBusinessObject) {
        
        nftImageView.kf.setImage(with: businessObject.imageURL, placeholder: UIImage(named: "Placeholder"))
        nftNameLabel.text = businessObject.name
        nftPriceLabel.text = "\(businessObject.price) ETH"
        likeImageView.image = businessObject.isLiked ? UIImage(named: "Liked") : UIImage(named: "NotLiked")
        orderImageView.image = businessObject.isOrdered ? UIImage(named: "Ordered") : UIImage(named: "NotOrdered")
        nftRatingView.rating = businessObject.rating
    }
    
    // MARK: - Private Properties
    private func setupLayout() {
        
        contentView.addSubview(nftImageView)
        contentView.addSubview(nftRatingView)
        contentView.addSubview(nftNameLabel)
        contentView.addSubview(orderImageView)
        contentView.addSubview(nftPriceLabel)
        contentView.addSubview(likeImageView)
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: nftRatingView.topAnchor, constant: -8),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftRatingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftRatingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftRatingView.heightAnchor.constraint(equalToConstant: 12),
            nftRatingView.bottomAnchor.constraint(equalTo: nftNameLabel.topAnchor, constant: -4),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: orderImageView.leadingAnchor),
            nftNameLabel.bottomAnchor.constraint(equalTo: nftPriceLabel.topAnchor),
            orderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            orderImageView.topAnchor.constraint(equalTo: nftRatingView.bottomAnchor, constant: 4),
            orderImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            orderImageView.heightAnchor.constraint(equalToConstant: 40),
            orderImageView.widthAnchor.constraint(equalToConstant: 40),
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftPriceLabel.trailingAnchor.constraint(equalTo: orderImageView.leadingAnchor),
            nftPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftPriceLabel.heightAnchor.constraint(equalToConstant: 12),
            likeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeImageView.heightAnchor.constraint(equalToConstant: 40),
            likeImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
