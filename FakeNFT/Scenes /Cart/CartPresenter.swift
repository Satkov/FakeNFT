import UIKit

protocol CartPresenterProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource {
    func showFilters()
}

enum CartState {
    case initial, loading, failed(Error), data
}

enum CartFilterChoice {
    case price, name, rating
}

class CartPresenter: NSObject {
    weak var view: CartViewProtocol?
    var router: CartRouterProtocol
    var interactor: CartInteractorProtocol

    private var orderItems: Order?
    private var nftsInCart: [Nft] = []
    private var state: CartState = CartState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(
        interactor: CartInteractorProtocol,
        router: CartRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
        super.init()
        getOrder()
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            print("loading")
            // показать лоудер
        case .failed(let error):
            print(error)
            // показать алерт об ошибке
        case .data:
            print("data")
            getTotalInfo()
            view?.displayTable()
            
            // отфильтровать
            // перезагрузить таблицу
            // сказать контроллеру отрисовать таблицу
            // посчитать общую стоимость нфт в корзине
        }
    }

    private func getOrder() {
        state = .loading
        interactor.getNFTInsideCart() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let order):
                orderItems = order
                getNfts()
            case .failure(let error):
                state = .failed(error)
            }
        }
    }

    private func getNfts() {
        guard let orderItems else { return }
        let dispatchGroup = DispatchGroup()
        nftsInCart = []
        for id in orderItems.nfts {
            dispatchGroup.enter()
            interactor.getNFTByID(id: id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    nftsInCart.append(nft)
                case .failure(let error):
                    state = .failed(error)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            state = .data
        }
    }

    private func getTotalInfo() {
        var totalPrice: Float = 0
        var numberOfItems = 0
        nftsInCart.forEach() { item in
            numberOfItems += 1
            totalPrice += item.price
        }
        view?.fillPaymentBlockView(
            totalPrice: totalPrice.toString(),
            numberOfItems: numberOfItems.toString()
        )
    }

    func filterNftBy(filterChoice: CartFilterChoice) {
        switch filterChoice {
        case .price:
            NftFilters.filterByPrice(nft: &nftsInCart)
        case .name:
            NftFilters.filterByName(nft: &nftsInCart)
        case .rating:
            NftFilters.filterByRating(nft: &nftsInCart)
        }
        view?.reloadTable()
    }
}

extension CartPresenter: CartPresenterProtocol {
    func showFilters() {
        let buttons = [
            FilterMenuButtonModel(title: Localization.filterChoicePrice, action: { [weak self] in
                guard let self else { return }
                filterNftBy(filterChoice: .price)
            }),
            FilterMenuButtonModel(title: Localization.filterChoiceRating, action: { [weak self] in
                guard let self else { return }
                filterNftBy(filterChoice: .rating)
            }),
            FilterMenuButtonModel(title: Localization.filterChoiceName, action: { [weak self] in
                guard let self else { return }
                filterNftBy(filterChoice: .name)
            }),
        ]
        let filterVC = FilterViewController(buttons: buttons)
        router.showCartFilters(filterVC: filterVC)
    }
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
        nftsInCart.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as! CartTableViewCell

        let nft = nftsInCart[indexPath.row]
        cell.configurate(
            imageURL: nft.images[0],
            name: nft.name,
            rating: nft.rating,
            price: nft.price
        )
        return cell
    }
}
