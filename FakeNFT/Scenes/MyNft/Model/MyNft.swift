struct MyNft: Decodable {
    let name: String
    let image: String
    let rating: Int
    let price: Float
    let author: String
    let id: String
    var isLiked: Bool
}
