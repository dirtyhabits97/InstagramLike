//
//  UserProfilePhotoCell.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/12/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    // MARK: - Object Variables
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            setupPostPhoto(withUrl: imageUrl)
        }
    }
    
    
    // MARK: - Interface Objects
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhotoImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    fileprivate func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    fileprivate func setupPostPhoto(withUrl stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("Failed to fetch post image: ", err)
                return
            }
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.photoImageView.image = photoImage
            }
        }.resume()
    }
}
