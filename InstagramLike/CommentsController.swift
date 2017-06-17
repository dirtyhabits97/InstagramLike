//
//  CommentsController.swift
//  InstagramLike
//
//  Created by GERH on 6/16/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit


class CommentsController: UICollectionViewController {
    
    // MARK: - Object Variables
    var post: Post?
    
    // MARK: - CommentsController Properties
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    // MARK: - Interface Objects
    var width: CGFloat?
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: self.width!, height: 50)
        
        let submitButon = UIButton(type: .system)
        submitButon.setTitle("Submit", for: .normal)
        submitButon.setTitleColor(.black, for: .normal)
        submitButon.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButon.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        
        containerView.addSubview(submitButon)
        containerView.addSubview(textField)
        submitButon.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(containerView)
            make.right.equalTo(containerView.snp.right).offset(-12)
            make.width.equalTo(50)
        }
        textField.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(containerView)
            make.right.equalTo(submitButon.snp.left).offset(-4)
            make.left.equalTo(containerView).offset(12)
        }
        
        return containerView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.frame.width
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Comments"
        view.backgroundColor = UIColor.cyan
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        resignFirstResponder()
    }
    
    // MARK: - Handle Methods
    
    func handleSubmit() {
        print("Handling Submit...")
    }
}
