protocol MyNftInteractorProtocol: AnyObject {
    func fetchNFTs()
}

class MyNftInteractor: MyNftInteractorProtocol {
    weak var presenter: MyNftPresenterProtocol?

    private let mockNFTs: [Nft] = [
        Nft(
            createdAt: "",
            name: "Fall",
            images: [],
            rating: 3,
            description: "",
            price: 1.23,
            author: "John Doe",
            id: "1"
        ),
        Nft(
            createdAt: "",
            name: "Spring",
            images: [],
            rating: 3,
            description: "",
            price: 1.23,
            author: "John Doe",
            id: "2"
        ),
        Nft(
            createdAt: "",
            name: "Summer",
            images: [],
            rating: 3,
            description: "",
            price: 1.23,
            author: "John Doe",
            id: "3"
        ),
    ]

    func fetchNFTs() {
        presenter?.didFetchNFTs(mockNFTs)
    }
}
