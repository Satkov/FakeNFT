import UIKit


protocol PaymentPagePresenterProtocol: AnyObject, UICollectionViewDelegate, UICollectionViewDataSource {
    func showWebView()
}

class PaymentPagePresenter: NSObject {
    weak var view: PaymentPageViewProtocol?
    var router: PaymentPageRouterProtocol
    var interactor: PaymentPageInteractorProtocol

    init(interactor: PaymentPageInteractorProtocol, router: PaymentPageRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension PaymentPagePresenter: PaymentPagePresenterProtocol {
    func showWebView() {
        router.showWebView()
    }
}

extension PaymentPagePresenter: UICollectionViewDelegate {

}

extension PaymentPagePresenter: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentMethodCollectionViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? PaymentMethodCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        cell.configure(
            imageUrlString: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Dogecoin_(DOGE).png",
            currencyName: "Dogecoin",
            currencyShortName: "DOGECOIN"
        )
        return cell
    }
    

}
