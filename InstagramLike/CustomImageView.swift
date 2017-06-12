//
//  CustomImageView.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/12/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

var imageCache = [String:UIImage]()

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        lastUrlUsedToLoadImage = urlString
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("Failed to fetch post image: ", err)
                return
            }
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}
