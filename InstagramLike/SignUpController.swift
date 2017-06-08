//
//  ViewController.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/5/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - Interface Objects
    
    let plusPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = UIColor(r: 149, g: 204, b: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Handle Methods
    
    func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let err = error {
                print("Failed to create user: ", err)
                return
            }
            print("Succesfully created user", user?.uid ?? "")
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            let filename = NSUUID().uuidString
            FIRStorage.storage().reference().child("profile_images").child(filename).put(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to upload profile image: ", err)
                    return
                }
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                print("Succesfully uploaded profile image: ", profileImageUrl)
                
                guard let uid = user?.uid else { return }
                let dictionaryValues = ["username":username, "profileImageUrl":profileImageUrl]
                let values = [uid : dictionaryValues]
                
                FIRDatabase.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, reference) in
                    //reference is a reference to Firebase database
                    if let err = err {
                        print("Failed to save user info into db: ", err)
                        return
                    }
                    print("Succesfully saved the user into the database")
                })

            })
            
        })
    }
    
    func handleTextInputChange() {
        let isFormValid = !(emailTextField.text?.isEmpty ?? true) && !(usernameTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
        signupButton.backgroundColor = isFormValid ? UIColor(r: 17, g: 154, b: 237) : UIColor(r: 149, g: 204, b: 244)
        signupButton.isEnabled = isFormValid ? true : false
    }
    
    func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: - View Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()        
        setupInputFields()
    }
    
    fileprivate func setupViews() {
        view.addSubview(plusPhotoButton)
        plusPhotoButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(140)
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(40)
        }
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField, signupButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(plusPhotoButton.snp.bottom).offset(20)
            make.left.equalTo(view).offset(40)
            make.right.equalTo(view).offset(-40)
            make.height.equalTo(200)
        }
    }
    
    // MARK: - ImagePickerController Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage, for: .normal)
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage, for: .normal)
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
    }

}
