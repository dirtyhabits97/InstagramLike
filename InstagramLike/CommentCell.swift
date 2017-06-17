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
            print(comment?.text)
            textLabel.text = comment?.text
        }
    }
    
    // MARK: - Interface Objects
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.backgroundColor = .cyan
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        setupCommetText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    fileprivate func setupCommetText() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        }
    }
}
