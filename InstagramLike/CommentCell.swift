//
//  CommentCell.swift
//  InstagramLike
//
//  Created by GERH on 6/16/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit

class CommentCell: UICollectionViewCell {
    
    // MARK: - Object Variables
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            commenttextView.text = comment.text
            profileImageView.loadImage(with: comment.user.profileImageUrl)
            setupAttributedCommentText()
        }
    }
    
    // MARK: - Interface Objects
    let commenttextView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        return tv
    }()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
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
        addSubview(commenttextView)
        addSubview(profileImageView)
        commenttextView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(self).inset(UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 4))
            make.left.equalTo(profileImageView.snp.right).offset(4)
        }
        profileImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(8)
            make.width.height.equalTo(40)
        }
        profileImageView.layer.cornerRadius = 40 / 2
        
    }
    fileprivate func setupAttributedCommentText() {
        guard let comment = self.comment else { return }
        
        let attributedText = NSMutableAttributedString(string: "\(comment.user.username): ", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: comment.text, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = comment.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:UIColor.gray]))
        
        commenttextView.attributedText = attributedText
    }
}
