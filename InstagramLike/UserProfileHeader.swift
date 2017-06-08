//
//  UserProfileHeader.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/7/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit

class UserProfileHeader: UICollectionViewCell {
    
    // MARK: - Object Variables
    
    var user: User? {
        didSet {
            print("Hello")
            setupProfileImage()
        }
    }
    
    
    // MARK: - Interface Objects
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.layer.cornerRadius = 80/2
        iv.clipsToBounds = true
        return iv
    }()
    
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        setupViews()
    }
    
    
    // MARK: - Setup Methods
    
    fileprivate func setupViews() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(12)
            make.height.width.equalTo(80)
        }
    }
    
    fileprivate func setupProfileImage() {
        print("yo waddup")
        guard let profileImageUrl = user?.profileImageUrl else { print("1");return }
        guard let url = URL(string: profileImageUrl) else { print("2");return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("Failed to fetch profile image: ", err)
                return
            }
            guard let data = data else { print("3");return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            }.resume()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
