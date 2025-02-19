//
//  NFTCollectionListRequest.swift
//  FakeNFT
//
//  Created by Nikolay on 17.02.2025.
//

import Foundation

struct NFTCollectionListRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var dto: Dto?
}
