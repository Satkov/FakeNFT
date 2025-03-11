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
        label.font = .sfProBold17
        label.textColor = .projectBlack
        return label
    }()
    private var nftRatingView = RatingView()
    private var nftAuthorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .projectBlack
        label.numberOfLines = 1
        label.font = .sfRegular13
        return label
    }()
    private var nftPriceHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .sfRegular13
        label.textColor = .projectBlack
        label.text = Localization.price
        return label
    }()
    private var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProBold17
        label.textColor = .projectBlack
        return label
    }()
    private let middleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [nftNameLabel, nftRatingView, nftAuthorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            middleStackView.addArrangedSubview($0)
        }
        
        [nftPriceHeaderLabel, nftPriceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            priceStackView.addArrangedSubview($0)
        }
        
        addSubview(middleStackView)
        addSubview(priceStackView)
        addSubview(nftImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
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
        nftRatingView.rating = nft.rating
        let author = "от \(nft.author)"
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.sfRegular13 ?? UIFont()
        ]
        let attributedString = NSMutableAttributedString(string: author, attributes: defaultAttributes)
        let otRange = NSRange(location: 0, length: 2)
        attributedString.addAttribute(.font, value: UIFont.sfRegular15 ?? UIFont(), range: otRange)
        nftAuthorLabel.attributedText = attributedString
    }
}
