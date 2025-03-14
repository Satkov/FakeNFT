import Foundation

struct UpdateProfileDto: Dto {
    let profile: Profile

    func asDictionary() -> [String: String] {
        return ["name": profile.name,
                "description": profile.description,
                "website": profile.website,
                "likes": profile.likes.joined(separator: ",")]
    }
}
