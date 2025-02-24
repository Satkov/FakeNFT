import UIKit

final class PaymentBlockView: UIView {
    let payButton: UIButton = {
        let button = UIButton()
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 16
        return button
    }()

    let nftCounterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.greenUniversal
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = UIColor.lightGray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurate(totalPrice: String, numberOfItems: String) {
        nftCounterLabel.text = "\(numberOfItems) NFT"
        totalPriceLabel.text = "\(totalPrice) ETH"
    }

    private func setupConstraints() {
        payButton.translatesAutoresizingMaskIntoConstraints = false
        nftCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(payButton)
        addSubview(nftCounterLabel)
        addSubview(totalPriceLabel)

        NSLayoutConstraint.activate([
            nftCounterLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            nftCounterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            nftCounterLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: nftCounterLabel.bottomAnchor, constant: 2),
            totalPriceLabel.leadingAnchor.constraint(equalTo: nftCounterLabel.leadingAnchor),
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 22)
        ])

        NSLayoutConstraint.activate([
            payButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            payButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            payButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
}
