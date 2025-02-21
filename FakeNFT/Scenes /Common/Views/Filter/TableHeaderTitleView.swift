import UIKit

final class TableHeaderTitleView: UIView {
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "SF Pro Regular", size: 13)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.projectGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.filterMenuBorder
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func configurate(title: String) {
        titleLabel.text = title
        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.addToSuperview(self)
        separatorView.addToSuperview(self)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
