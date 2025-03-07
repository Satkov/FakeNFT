import UIKit
final class NFTCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "NFTCollectionViewCell"

    private var isLiked: Bool = false {
        didSet {
            updateLikeButton(isLiked: isLiked)
        }
    }

    private var isInCart: Bool = false {
        didSet {
            updateCartButton(isInCart: isInCart)
        }
    }

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heartWhite"), for: .normal)
        return button
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black
        return label
    }()

    private let cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cart1"), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12

        [nftImageView, likeButton, ratingImageView, nameLabel, priceLabel, cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),

            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),

            ratingImageView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            ratingImageView.heightAnchor.constraint(equalToConstant: 12),

            nameLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cartButton.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 4),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(with nft: NFT) {
        if let imageUrl = nft.images.first {
            ImageLoader.shared.loadImage(from: imageUrl) { [weak self] image in
                self?.nftImageView.image = image
            }
        }
        
        nameLabel.text = nft.name.components(separatedBy: " ").first ?? nft.name
        updateRating(nft.rating)
        let priceString = String(format: "%.2f", nft.price).replacingOccurrences(of: ".", with: ",")
        priceLabel.text = "\(priceString) ETH"
    }

    private func updateRating(_ rating: Int) {
        let ratingImageName: String
        switch rating {
        case 0:
            ratingImageName = "zero"
        case 1:
            ratingImageName = "one"
        case 2:
            ratingImageName = "two"
        case 3:
            ratingImageName = "three"
        case 4:
            ratingImageName = "four"
        case 5:
            ratingImageName = "five"
        default:
            ratingImageName = "zero"
        }

        ratingImageView.image = UIImage(named: ratingImageName)
    }

    private func updateLikeButton(isLiked: Bool) {
        let imageName = isLiked ? "heartRed" : "heartWhite"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }

    private func updateCartButton(isInCart: Bool) {
        let imageName = isInCart ? "cart2" : "cart1"
        cartButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @objc private func cartButtonTapped() {
        isInCart.toggle()
    }
    
    @objc private func likeButtonTapped() {
        isLiked.toggle()
    }
}
