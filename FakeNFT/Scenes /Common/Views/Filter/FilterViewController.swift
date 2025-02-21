import UIKit

final class FilterViewController: UIViewController {
    private lazy var buttonsTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 13
        return tableView
    }()

    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont(name: "SF Pro Semibold", size: 20)
        button.setTitleColor(UIColor.filterMenuText, for: .normal)
        button.layer.cornerRadius = 13
        return button
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.projectBlack.withAlphaComponent(0)
        return view
    }()

    private let buttons: [FilterMenuButtonModel]

    init(buttons: [FilterMenuButtonModel]) {
        self.buttons = buttons
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAppearance()
    }

    private func setupTableView() {
        buttonsTableView.delegate = self
        buttonsTableView.dataSource = self
        buttonsTableView.isScrollEnabled = false

        if #available(iOS 15.0, *) {
            buttonsTableView.sectionHeaderTopPadding = 0
        }

        // Blur
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = buttonsTableView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        buttonsTableView.backgroundView = blurView
        buttonsTableView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
    }

    private func setupUI() {
        backgroundView.addToSuperview(view)
        buttonsTableView.addToSuperview(view)
        exitButton.addToSuperview(view)

        setupConstraints()
        prepareForAnimation()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            exitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            exitButton.heightAnchor.constraint(equalToConstant: 60),

            buttonsTableView.bottomAnchor.constraint(equalTo: exitButton.topAnchor, constant: -8),
            buttonsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            buttonsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            buttonsTableView.heightAnchor.constraint(equalToConstant: CGFloat(42 + (60 * buttons.count)))
        ])
    }

    private func prepareForAnimation() {
        buttonsTableView.transform = CGAffineTransform(translationX: 0, y: 300)
        exitButton.transform = CGAffineTransform(translationX: 0, y: 300)
        buttonsTableView.alpha = 0
        exitButton.alpha = 0
    }

    private func animateAppearance() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundView.backgroundColor = UIColor.projectBlack.withAlphaComponent(0.5)
            self.buttonsTableView.transform = .identity
            self.exitButton.transform = .identity
            self.buttonsTableView.alpha = 1
            self.exitButton.alpha = 1
        })
    }

    private func animateDismiss() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.backgroundView.backgroundColor = UIColor.projectBlack.withAlphaComponent(0)
                self.buttonsTableView.transform = CGAffineTransform(translationX: 0, y: 300)
                self.exitButton.transform = CGAffineTransform(translationX: 0, y: 300)
                self.buttonsTableView.alpha = 0
                self.exitButton.alpha = 0
            },
            completion: { [weak self] _ in
                self?.dismiss(animated: false)
            }
        )
    }

    @objc
    private func exitButtonPressed() {
        animateDismiss()
    }

}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TableHeaderTitleView()
        headerView.configurate(title: NSLocalizedString("Filter.table.title", comment: ""))
        return headerView
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        buttons[indexPath.row].action()
        animateDismiss()
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        60
    }

    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        42
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        buttons.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell()
        let buttonModel = buttons[indexPath.row]
        cell.textLabel?.text = buttonModel.title
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "SF Pro Regular", size: 20)
        cell.textLabel?.textColor = UIColor.filterMenuText
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
}
