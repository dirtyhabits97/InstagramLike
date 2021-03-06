//
//  UserProfileHeader.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/7/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    // MARK: - Object Variables
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(with: profileImageUrl)
            usernameLabel.text = user?.username
            setupEditFollowButton()
        }
    }
    
    weak var delegate: UserProfileHeaderDelegate?
    
    // MARK: - Interface Objects
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = 80/2
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        //        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSForegroundColorAttributeName:UIColor.lightGray, NSFontAttributeName:UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.numberOfLines  = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSForegroundColorAttributeName:UIColor.lightGray, NSFontAttributeName:UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.numberOfLines  = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "following", attributes: [NSForegroundColorAttributeName:UIColor.lightGray, NSFontAttributeName:UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.numberOfLines  = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileImageView()
        setupBottomToolBar()
        setupUsernameLabel()
        setupUserStatsViews()
        setupEditProfileButton()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Methods
    
    fileprivate func setupProfileImageView() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(12)
            make.height.width.equalTo(80)
        }
    }
    fileprivate func setupUsernameLabel() {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.bottom.equalTo(gridButton.snp.top)
        }
    }
    fileprivate func setupBottomToolBar() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton,  bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        stackView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(50)
        }
        topDividerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(stackView.snp.top)
            make.height.equalTo(0.5)
        }
        bottomDividerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(stackView.snp.bottom)
            make.height.equalTo(0.5)
        }
    }
    fileprivate func setupUserStatsViews() {
        let stackview = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackview.distribution = .fillEqually
        addSubview(stackview)
        stackview.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(12)
            make.left.equalTo(profileImageView.snp.right).offset(12)
            make.right.equalTo(self).offset(-12)
            make.height.equalTo(50)
        }
    }
    fileprivate func setupEditProfileButton() {
        addSubview(editProfileFollowButton)
        editProfileFollowButton.snp.makeConstraints { (make) in
            make.top.equalTo(postsLabel.snp.bottom).offset(2)
            make.left.equalTo(postsLabel)
            make.right.equalTo(followingLabel)
            make.height.equalTo(34)
        }
    }
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        if currentLoggedUserId == userId {
            //TODO
        } else {
            let ref = FIRDatabase.database().reference().child("following").child(currentLoggedUserId).child(userId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                } else {
                    self.setFollowStyle()
                }
                
            }, withCancel: { (error) in
                print("Failed to fetch following users: ", error)
            })
        }
    }
    
    fileprivate func setFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .mainBlue()
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    fileprivate func setUnfollowStyle() {
        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .white
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
    }
    
    
    // MARK: - Handle Methods
    
    func handleEditProfileOrFollow() {
        guard let currentLoggedInUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            let reference = FIRDatabase.database().reference().child("following").child(currentLoggedInUserId).child(userId)
            reference.removeValue(completionBlock: { (error, ref) in
                if let err = error {
                    print("Failed to unfollow user", err)
                    return
                }
                print("Succesfully unfollowed user: ", self.user?.username ?? "")
                self.setFollowStyle()
            })
        } else if editProfileFollowButton.titleLabel?.text == "Follow" {
            let reference = FIRDatabase.database().reference().child("following").child(currentLoggedInUserId)
            let values = [userId : 1]
            reference.updateChildValues(values) { (error, ref) in
                if let err = error {
                    print("Failed to follow user: ", err)
                    return
                }
                print("Succesfully followed user: ", self.user?.username ?? "")
                self.setUnfollowStyle()
            }
        }
    }
    func handleChangeToListView() {
        listButton.tintColor = UIColor.mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    func handleChangeToGridView() {
        gridButton.tintColor = UIColor.mainBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
}
