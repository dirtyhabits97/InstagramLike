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
            photoImageView.loadImage(with: imageUrl)
        }
    }
    
    
    // MARK: - Interface Objects
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
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
}
