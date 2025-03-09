import Foundation

struct UpdateOrderDto: Dto {
    let nfts: [String]

    func asDictionary() -> [String: String] {
        if nfts.isEmpty {
            return [:]
        }
        let value = nfts.joined(separator: ", ")
        return ["nfts": value]
    }
}
