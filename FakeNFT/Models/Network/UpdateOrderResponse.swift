import Foundation

struct UpdateOrderResponse: Decodable {
    let nfts: [String]
    let id: String

    enum CodingKeys: String, CodingKey {
        case nfts
        case id
    }
}
