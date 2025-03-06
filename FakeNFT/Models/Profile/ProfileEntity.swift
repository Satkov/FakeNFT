import Foundation

struct ProfileEntity: Decodable {
    let id: String
    let name: String
    let website: String?
    let description: String?
    let avatarURL: String?
    let nfts: [String]?
}
