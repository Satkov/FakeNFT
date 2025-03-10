import Foundation

protocol NftStorage: AnyObject {
//    func saveNft(_ nft: NftShort)
//    func getNft(with id: String) -> NftShort?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImpl: NftStorage {
    private var storage: [String: Nft] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

//    func saveNft(_ nft: NftShort) {
//        syncQueue.async { [weak self] in
//            self?.storage[nft.id] = nft
//        }
//    }

//    func getNft(with id: String) -> NftShort? {
//        syncQueue.sync {
//            storage[id]
//        }
//    }
}
