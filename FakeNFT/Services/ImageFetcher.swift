import UIKit
import Kingfisher

enum ImageFetcherError: Error {
    case invalidURL
}

class ImageFetcher {
    static let shared = ImageFetcher()
    private let cache = ImageCache.default

    private init() {}

    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(ImageFetcherError.invalidURL))
            return
        }

        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                completion(.success(value.image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
