//
//  PreviewPhotoContainerView.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/14/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    // MARK: - Interface Objects
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
        setupPreviewImageView()
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    fileprivate func setupPreviewImageView() {
        addSubview(previewImageView)
        previewImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    fileprivate func setupButtons() {
        addSubview(cancelButton)
        addSubview(saveButton)
        cancelButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.left.equalTo(self).offset(12)
        }
        saveButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.bottom.equalTo(self).offset(-24)
            make.left.equalTo(self).offset(24)
        }
    }
    fileprivate func setupSavedLabel() {
        let savedLabel = UILabel()
        savedLabel.text = "Saved Succesfully"
        savedLabel.textColor = .white
        savedLabel.font = .boldSystemFont(ofSize: 18)
        savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
        savedLabel.numberOfLines = 0
        savedLabel.textAlignment = .center
        // is better to use a frame when animating somethign in and out of a view
        savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        savedLabel.center = self.center
        
        self.addSubview(savedLabel)
        savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        }) { (completed) in
            // TODO
            UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                savedLabel.alpha = 0
                
            }, completion: { (_) in
                savedLabel.removeFromSuperview()
            })
        }
    }
    // MARK: - Handle Methods
    
    func handleCancel() {
        self.removeFromSuperview()
    }
    func handleSave() {
        guard let previewImage = previewImageView.image else { return }
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, err) in
            if let err = err {
                print("Failed to save image to photo library: ", err)
                return
            }
            print("Succesfully saved image to library")
            DispatchQueue.main.async {
                self.setupSavedLabel()
            }
        }
    }
}
