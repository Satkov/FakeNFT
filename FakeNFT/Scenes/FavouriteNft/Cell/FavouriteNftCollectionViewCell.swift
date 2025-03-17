import UIKit

final class FavouriteNftCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    var onLikeButtonTapped: ((Nft) -> Void)?
    
    //MARK: - Private
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likeButton = LikeButton()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProBold17
        label.textColor = .projectBlack
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingView: RatingView = {
        let ratingView = RatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .sfRegular15
        label.textColor = .projectBlack
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nft: Nft? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func initialize() {
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(priceLabel)
    
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 76),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 92),
            
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8),
            priceLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 76),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
        ])
        
        likeButton.addTarget(self, action: #selector(didTapLikedNftButton), for: .touchUpInside)
    }
    
    @objc private func didTapLikedNftButton() {
        guard let nft else { return }
        onLikeButtonTapped?(nft)
    }
}

extension FavouriteNftCollectionViewCell {
    func configure(favouriteNft: Nft) {
        self.nft = favouriteNft
        imageView.loadImage(urlString: favouriteNft.images[0])
        likeButton.isLiked = true
        nameLabel.text = favouriteNft.name
        ratingView.rating = favouriteNft.rating
        priceLabel.text = "\(favouriteNft.price) ETH"
    }
}
