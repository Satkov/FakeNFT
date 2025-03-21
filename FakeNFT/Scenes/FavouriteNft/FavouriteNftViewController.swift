import UIKit
import ProgressHUD

protocol FavouriteNftViewProtocol: AnyObject {
    func updateForNewData()
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
}

final class FavouriteNftViewController: UICollectionViewController {
    // MARK: - Public
    var presenter: FavouriteNftPresenterProtocol?

    private let emptyCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет избранных NFT"
        label.textAlignment = .center
        label.font = .sfProBold17
        label.textColor = .projectBlack
        return label
    }()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoad()
    }
}

// MARK: - Private functions
private extension FavouriteNftViewController {
    func initialize() {
        title = "Избранные NFT"
        collectionView.backgroundColor = .projectWhite
        collectionView.register(FavouriteNftCollectionViewCell.self)
    }
    
    func updateBackgroundViewIfNeeded() {
        if presenter?.favouriteNfts.isEmpty == true {
            collectionView.backgroundView = emptyCollectionLabel
        } else {
            collectionView.backgroundView = nil
        }
    }
        
}

// MARK: - FavouriteNftViewProtocol
extension FavouriteNftViewController: FavouriteNftViewProtocol {
    func updateForNewData() {
        collectionView.reloadData()
        updateBackgroundViewIfNeeded()
    }
    
    func showError(_ message: String) {
        ProgressHUD.dismiss()
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showLoading() {
        ProgressHUD.show("Загрузка...", interaction: false)
    }
    
    func hideLoading() {
        ProgressHUD.dismiss()
    }
}

extension FavouriteNftViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return presenter?.favouriteNfts.count ?? 0
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: FavouriteNftCollectionViewCell = collectionView.dequeueReusableCell(
            indexPath: indexPath
        )

        if let favouriteNft = presenter?.favouriteNfts[indexPath.row] {
            cell.configure(favouriteNft: favouriteNft)
        }
        cell.onLikeButtonTapped = { [weak self] favouriteNft in
            guard let self = self else { return }
            self.presenter?.updateFavoriteStatus(favouriteNft: favouriteNft)
        }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 168, height: 80)
    }
}
