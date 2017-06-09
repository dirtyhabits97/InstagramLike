//
//  SharePhotoController.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/9/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
    
    // MARK: - Object Variables
    
    var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }
    
    // MARK: - Property Variables
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Interface Objects
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        return tv
    }()
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        setupImageAndTextViews()
    }
    
    
    // MARK: - Setup Methods
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.right.left.equalTo(view)
            make.height.equalTo(100)
        }
        containerView.addSubview(imageView)
        containerView.addSubview(textView)
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(containerView).offset(8)
            make.bottom.equalTo(containerView).offset(-8)
            make.width.equalTo(84)
        }
        textView.snp.makeConstraints { (make) in
            make.top.right.equalTo(view).offset(8)
            make.left.equalTo(imageView.snp.right).offset(4)
        }
    }
    
    
    // MARK: - Handle Methods
    
    func handleShare() {
        
    }
    
    
}
