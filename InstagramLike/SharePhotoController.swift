//
//  SharePhotoController.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/9/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import Firebase

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
            make.top.right.bottom.equalTo(containerView)
            make.left.equalTo(imageView.snp.right).offset(4)
        }
    }
    
    
    // MARK: - Handle Methods
    
    func handleShare() {
        guard let caption = textView.text, !caption.isEmpty else { return }
        guard let image = selectedImage else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
        navigationItem.rightBarButtonItem?.isEnabled = false
        let filename = NSUUID().uuidString
        FIRStorage.storage().reference().child("posts").child(filename).put(uploadData, metadata: nil) { (metadata, error) in
            if let err = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image: ", err)
                return
            }
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            print("Succesfully uploaded post image: ", imageUrl)
            self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = imageView.image else { return }
        guard let caption = textView.text else { return }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let userPostRef = FIRDatabase.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values = ["imageUrl":imageUrl, "imageWidth" : postImage.size.width, "imageHeigth": postImage.size.height, "caption":caption, "creationDate" : Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (error, ref) in
            if let err = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB: ", err)
                return
            }
            print("Succesfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
