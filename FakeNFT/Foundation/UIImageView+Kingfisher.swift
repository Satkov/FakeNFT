//
//  UIImageView+Kingfisher.swift
//  FakeNFT
//
//  Created by Alibi Mailan on 03.03.2025.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(urlString: String?, defaultImage: UIImage? = nil) {
        if let urlString = urlString, let url = URL(string: urlString) {
            kf.setImage(with: url, placeholder: defaultImage)
        } else {
            image = defaultImage
        }
    }
}
