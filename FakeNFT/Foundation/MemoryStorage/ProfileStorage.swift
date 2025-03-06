import Foundation

protocol ProfileStorage: AnyObject {
    func saveProfile(_ profile: ProfileEntity)
    func getProfile(with id: String) -> ProfileEntity?
}

final class ProfileStorageImpl: ProfileStorage {
    private var storage: [String: ProfileEntity] = [:]

    private let syncQueue = DispatchQueue(label: "sync-profile-queue")

    func saveProfile(_ profile: ProfileEntity) {
        syncQueue.async { [weak self] in
            self?.storage[profile.id] = profile
        }
    }

    func getProfile(with id: String) -> ProfileEntity? {
        syncQueue.sync {
            storage[id]
        }
    }
}
