import UIKit

final class CartTableViewCell: UITableViewCell, ReuseIdentifying {
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private let ratingView: RatingView = {
        let view = RatingView()
        return view
    }()

    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "deleteButtonIcon"), for: .normal)
        button.tintColor = .black
        return button
    }()


    func configurate() {
        nftImageView.image = UIImage(named: "mockImage")
        nameLabel.text = "mock name"
        ratingView.rating = 4
        priceTitleLabel.text = "Цена"
        priceLabel.text = "50 рублей"
        setupUI()
    }

    private func setupUI() {
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(nftImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(priceTitleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108)
        ])

        NSLayoutConstraint.activate([
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingView.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12)
        ])

        NSLayoutConstraint.activate([
            priceTitleLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            priceTitleLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 4),
            priceTitleLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 4),
            priceLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor)
        ])
    }
}

