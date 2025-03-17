import Foundation

struct ProfileByIdRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
    var dto: Dto?
    var httpMethod: HttpMethod = .get
}
