import Foundation

struct NetworkRequests {
    static func getNFTInsideCart() -> NetworkRequest {
        RequestBuilder(
            endpoint: URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1"),
            httpMethod: .get
        )
    }

    static func getNFTById(id: String) -> NetworkRequest {
        RequestBuilder(
            endpoint: URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)"),
            httpMethod: .get
        )
    }

    static func getCurrencies() -> NetworkRequest {
        RequestBuilder(
            endpoint: URL(string: "\(RequestConstants.baseURL)/api/v1/currencies"),
            httpMethod: .get
        )
    }
}
