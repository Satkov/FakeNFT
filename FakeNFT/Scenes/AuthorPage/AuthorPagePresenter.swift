//
//  AuthorPagePresenter.swift
//  Super easy dev
//
//  Created by Nikolay on 24.02.2025
//

import Foundation

protocol AuthorPagePresenterProtocol: AnyObject {
    func authorPageURLRequest() -> URLRequest
}

final class AuthorPagePresenter {
    weak var view: AuthorPageViewProtocol?
    var authorPageURL: URL

    init(url: URL) {
        self.authorPageURL = url
    }
}

extension AuthorPagePresenter: AuthorPagePresenterProtocol {
    
    func authorPageURLRequest() -> URLRequest {
        return URLRequest(url: authorPageURL)
    }
}
