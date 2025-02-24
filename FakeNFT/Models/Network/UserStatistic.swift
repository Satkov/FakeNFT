import Foundation

struct User: Decodable {
    let name: String
    let avatar: String
    let nfts: [String]
    let id: String
    
    var nftCount: Int {
        return nfts.count
    }
}
