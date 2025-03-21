import Foundation

struct ProfileEditingDto: Dto {
    var avatar: String
    var name: String
    var description: String
    var website: String
    
    func asDictionary() -> [String : String] {
        ["avatar": avatar,
         "name": name,
         "description": description,
         "website": website]
    }
}
