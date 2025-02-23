import UIKit

protocol CartPresenterProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource {
}

enum CartState {
    case initial, loading, failed(Error), data([Nft])
}

class CartPresenter: NSObject {
    weak var view: CartViewProtocol?
    var router: CartRouterProtocol
    var interactor: CartInteractorProtocol

    private let dispatchGroup = DispatchGroup()
    private var orderItems: Order?
    private var nftsInCart: [Nft] = []
    private var state: CartState = CartState.initial {
        didSet {
            stateChanged()
        }
    }

    init(interactor: CartInteractorProtocol, router: CartRouterProtocol) {
        self.interactor = interactor
        self.router = router
        super.init()
        loadCartItems()
    }

    private func stateChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            print("loading")
            // показать лоудер
        case .failed(let error):
            print(error)
            // показать алерт об ошибке
        case .data(let nft):
            print(nft)
            // отфильтровать
            // перезагрузить таблицу
            // сказать контроллеру отрисовать таблицу
        }
    }

    private func loadCartItems() {
        state = .loading
        getOrder()
        dispatchGroup.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let self else { return }
            self.getNfts()
        }
    }

    private func getOrder() {
        dispatchGroup.enter()
        interactor.getNFTInsideCart() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let order):
                self.orderItems = order
            case .failure(let error):
                state = .failed(error)
            }
            dispatchGroup.leave()
        }
    }

    private func getNfts() {
        guard let orderItems else { return }
        nftsInCart = []
        for id in orderItems.nfts {
            interactor.getNFTByID(id: id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    nftsInCart.append(nft)
                    state = .data(nftsInCart)
                case .failure(let error):
                    state = .failed(error)
                }
            }
        }
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
