//
//  UserSearchCell.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/12/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit

class UserSearchCell: UICollectionViewCell {
    
    // MARK: - Object Variables
    var user: User? {
        didSet {
            guard let url = user?.profileImageUrl else { return }
            profileImageView.loadImage(with: url)
            guard let username = user?.username else { return }
            
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 4)]))
            attributedText.append(NSAttributedString(string: "10 posts", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:UIColor.gray]))
            
            usernameLabel.attributedText = attributedText
        }
    }
    
    // MARK: - Interface Objects
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Methods
    
    fileprivate func setupViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(separatorView)
        profileImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(8)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        profileImageView.layer.cornerRadius = 50 / 2
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.top.bottom.right.equalTo(self)
        }
        separatorView.snp.makeConstraints { (make) in
            make.left.equalTo(usernameLabel)
            make.bottom.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}
