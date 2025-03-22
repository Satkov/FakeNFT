import Foundation

struct ProfileByIdRequest: NetworkRequest {
    var endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    var httpMethod: HttpMethod = .get
    var dto: Dto?
}
