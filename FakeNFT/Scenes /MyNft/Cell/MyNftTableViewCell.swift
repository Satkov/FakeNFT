//
//  MyNftTableViewCell.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 04.03.2025.
//

import Foundation
import UIKit

final class MyNftTableViewCell: UITableViewCell, ReuseIdentifying {
    
    private var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .projectBlack
        return label
    }()
    private var nftStarRatingView = StarRatingView()
    private var nftAuthorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .projectBlack
        label.numberOfLines = 1
        label.font = .caption1
        return label
    }()
    private var nftPriceHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .projectBlack
        label.text = Localization.price
        return label
    }()
    private var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .projectBlack
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let middleStackView = UIStackView()
        middleStackView.axis = .vertical
        middleStackView.spacing = 4
        middleStackView.alignment = .leading
        middleStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(middleStackView)
        
        [nftNameLabel, nftStarRatingView, nftAuthorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            middleStackView.addArrangedSubview($0)
        }
        
        let priceStackView = UIStackView()
        priceStackView.axis = .vertical
        priceStackView.spacing = 2
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(priceStackView)
        
        [nftPriceHeaderLabel, nftPriceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            priceStackView.addArrangedSubview($0)
        }
        
        addSubview(nftImageView)
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            middleStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            middleStackView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            
            priceStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 137),
            priceStackView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
        ])
    }
    
    func configure(with nft: Nft) {
        nftImageView.image = UIImage(named: "profileMockNft" + nft.id)
        nftNameLabel.text = nft.name
        nftPriceLabel.text = "\(nft.price) ETH"
        nftStarRatingView.setRating(nft.rating)
        let author = "от \(nft.author)"
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.caption2
        ]
        let attributedString = NSMutableAttributedString(string: author, attributes: defaultAttributes)
        let otRange = NSRange(location: 0, length: 2)
        attributedString.addAttribute(.font, value: UIFont.caption1, range: otRange)
        nftAuthorLabel.attributedText = attributedString
    }
}
