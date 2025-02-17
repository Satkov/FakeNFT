import UIKit

protocol CartPresenterProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource {
}

class CartPresenter: NSObject {
    weak var view: CartViewProtocol?
    var router: CartRouterProtocol
    var interactor: CartInteractorProtocol

    init(interactor: CartInteractorProtocol, router: CartRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension CartPresenter: CartPresenterProtocol {
}


extension CartPresenter: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 140
    }
}

extension CartPresenter: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 3
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as! CartTableViewCell

        cell.configurate()
        return cell
    }
    

}
