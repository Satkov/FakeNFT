import Foundation

protocol ProfileService {
    func loadProfile(id: String, completion: @escaping ProfileCompletion)
    func updateProfile(_ profile: Profile, completion: @escaping ProfileCompletion)
    func updateLikedNft(_ liked: [String], _ completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {
    
    private let networkClient: NetworkClient
    private let storage: ProfileStorage
    
    private var loadProfileTask: NetworkTask?
    private var updateProfileTask: NetworkTask?
    private var updateFavouritesTask: NetworkTask?
    
    init(networkClient: NetworkClient, storage: ProfileStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadProfile(id: String, completion: @escaping ProfileCompletion) {
        if let profile = storage.getProfile(with: id) {
            completion(.success(profile))
            return
        }
        
        loadProfileTask?.cancel()
        
        let request = ProfileByIdRequest()
        loadProfileTask = networkClient.send(request: request, type: Profile.self) { [weak self] result in
            self?.loadProfileTask = nil
            switch result {
            case .success(let profile):
                self?.storage.saveProfile(profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(_ profile: Profile, completion: @escaping ProfileCompletion) {
        let dto = ProfileEditingDto(avatar: profile.avatar, name: profile.name, description: profile.description, website: profile.website)
        let request = ProfileByIdRequest(httpMethod: .put, dto: dto)
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(_):
                self?.storage.saveProfile(profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateLikedNft(_ liked: [String], _ completion: @escaping ProfileCompletion) {
        updateFavouritesTask?.cancel()
        let dto = ProfileFavouritesDto(likes: liked)
        let request = ProfileByIdRequest(httpMethod: .put, dto: dto)
        
        updateFavouritesTask = networkClient.send(request: request, type: Profile.self) { [weak self] result in
            self?.updateFavouritesTask = nil
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
