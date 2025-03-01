import UIKit


protocol PaymentPagePresenterProtocol: AnyObject, UICollectionViewDelegate, UICollectionViewDataSource {
    func showWebView()
}

enum PaymentViewState {
    case initial, loading, failed(Error), data
}

class PaymentPagePresenter: NSObject {
    weak var view: PaymentPageViewProtocol? {
        didSet {
            loadCurrencies()
        }
    }
    var router: PaymentPageRouterProtocol
    var interactor: PaymentPageInteractorProtocol
    private var selectedCurrency: Currency?

    private var state: PaymentViewState = .initial {
        didSet { stateDidChanged() }
    }

    private var currencies: [Currency] = []

    init(interactor: PaymentPageInteractorProtocol, router: PaymentPageRouterProtocol) {
        self.interactor = interactor
        self.router = router
        super.init()
    }


    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoader()
        case .failed(let error):
            print(error)
            view?.hideLoader()
            // TODO: show alert
        case .data:
            print("data")
            view?.hideLoader()
            view?.showCollection()
        }
    }

    private func loadCurrencies() {
        state = .loading
        interactor.getCurrency { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let currency):
                self.currencies = currency
                self.state = .data
            case .failure(let error):
                print(error)
                self.state = .failed(error)
            }
        }
    }
}

extension PaymentPagePresenter: PaymentPagePresenterProtocol {
    func showWebView() {
        router.showWebView()
    }
}

extension PaymentPagePresenter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCurrency = currencies[indexPath.row]
        view?.reloadCollection()
    }
}

extension PaymentPagePresenter: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentMethodCollectionViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? PaymentMethodCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        let currency = currencies[indexPath.row]
        cell.configure(
            imageUrlString: currency.image,
            currencyName: currency.title,
            currencyShortName: currency.name
        )
        if currency.id == selectedCurrency?.id {
            cell.selectCell()
        }
        return cell
    }
}
