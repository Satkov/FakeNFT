import UIKit

protocol CartPresenterProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource {
    func showFilters()
}

enum CartState {
    case initial, loading, failed(Error), data
}

enum CartFilterChoice: String {
    case price, name, rating, none
}

final class CartPresenter: NSObject {
    weak var view: CartViewProtocol? {
        didSet {
            getOrder()
        }
    }
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
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            print("loading")
            view?.showLoader()
        case .failed(let error):
            print(error)
            // показать алерт об ошибке
            view?.hideLoader()
        case .data:
            print("data")
            view?.hideLoader()
            let choice = loadLastFilterChoice()
            filterNftBy(filterChoice: choice)
            getTotalInfo()
            view?.displayTable()
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

    private func filterNftBy(filterChoice: CartFilterChoice) {
        saveFilterChoice(filterChoice)
        switch filterChoice {
        case .price:
            NftFilters.filterByPrice(nft: &nftsInCart)
        case .name:
            NftFilters.filterByName(nft: &nftsInCart)
        case .rating:
            NftFilters.filterByRating(nft: &nftsInCart)
        case .none:
            return
        }
        view?.reloadTable()
    }

    private func saveFilterChoice(_ choice: CartFilterChoice) {
        UserDefaults.standard.set(choice.rawValue, forKey: "CartFilter")
    }

    private func loadLastFilterChoice() -> CartFilterChoice {
        guard let rawValue = UserDefaults.standard.string(forKey: "CartFilter"),
              let choice = CartFilterChoice(rawValue: rawValue) else {
            return .none
        }
        return choice
    }
}

extension CartPresenter: CartPresenterProtocol {
    func showFilters() {
        let buttons = [
            FilterMenuButtonModel(title: Localization.filterChoicePrice) { [weak self] in
                guard let self else { return }
                filterNftBy(filterChoice: .price)
            },
            FilterMenuButtonModel(title: Localization.filterChoiceRating) { [weak self] in
                guard let self else { return }
                filterNftBy(filterChoice: .rating)
            },
            FilterMenuButtonModel(title: Localization.filterChoiceName) { [weak self] in
                guard let self else { return }
                filterNftBy(filterChoice: .name)
            },
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
