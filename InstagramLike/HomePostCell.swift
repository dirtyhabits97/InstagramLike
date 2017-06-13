//
//  HomePostCell.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/12/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit

class HomePostCell: UICollectionViewCell {
    
    // MARK: - Object Variables
    var post: Post? {
        didSet {
            usernameLabel.text = post?.user.username
            guard let postImageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(with: postImageUrl)
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(with: profileImageUrl)
            setupAttributedCaption()
        }
    }
    
    // MARK: - Interface Objects
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActionButtons()
        setupCationLabel()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Methods
    fileprivate func setupViews() {
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        userProfileImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(8)
            make.width.height.equalTo(40)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userProfileImageView.snp.right).offset(8)
            make.top.equalTo(self)
            make.right.equalTo(optionsButton.snp.left)
            make.bottom.equalTo(photoImageView.snp.top)
        }
        optionsButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-8)
            make.centerY.equalTo(usernameLabel.snp.centerY)
            //apple recommendation
            make.width.equalTo(44)
        }
        photoImageView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(userProfileImageView.snp.bottom).offset(8)
            make.height.equalTo(photoImageView.snp.width)
        }
    }
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(bookmarkButton)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(photoImageView.snp.bottom)
            make.left.equalTo(self).offset(8)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        bookmarkButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-4)
            make.top.equalTo(photoImageView.snp.bottom)
            make.width.equalTo(40)
            make.height.equalTo(50)
        }
    }
    fileprivate func setupCationLabel() {
        addSubview(captionLabel)
        captionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(likeButton.snp.bottom)
            make.left.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-8)
            make.bottom.equalTo(self)
        }
        
    }
    fileprivate func setupAttributedCaption() {
        guard let username = post?.user.username else { return }
        guard let caption = post?.caption else { return }
        
        let attributedText = NSMutableAttributedString(string: "\(username): ", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: caption, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "1 week ago", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:UIColor.gray]))
        
        captionLabel.attributedText = attributedText
    }
    
}
