import Foundation

struct Nft: Decodable {
    let id: String
    let price: Double
    let rating: Int
    let name: String
    let author: String
    let images: [URL]
}
