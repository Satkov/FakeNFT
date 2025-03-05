//
//  ProfileByIdRequest.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 26.02.2025.
//

import Foundation

struct ProfileByIdRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
    var dto: Dto?
}
