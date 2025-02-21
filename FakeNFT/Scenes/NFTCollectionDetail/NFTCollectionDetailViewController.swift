//
//  NFTCollectionDetailViewController.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

import UIKit

protocol NFTCollectionDetailViewProtocol: AnyObject {
}

final class NFTCollectionDetailViewController: UIViewController {
    // MARK: - Public
    var presenter: NFTCollectionDetailPresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension NFTCollectionDetailViewController {
    func initialize() {
        view.backgroundColor = .white
    }
}

// MARK: - NFTCollectionDetailViewProtocol
extension NFTCollectionDetailViewController: NFTCollectionDetailViewProtocol {
}
