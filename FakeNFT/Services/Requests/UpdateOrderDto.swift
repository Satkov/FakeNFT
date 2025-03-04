import Foundation

struct UpdateOrderDto: Dto {
    func asDictionary() -> [String : String] {
        return [:]
    }
    
    var nfts: [String]
    
    init(nfts: [String]) {
        self.nfts = nfts
    }
}
