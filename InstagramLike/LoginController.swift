//
//  LoginController.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/7/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class LoginController: UIViewController {
    
    // MARK: - Interface Objects
    
    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints({ (make) in
            make.centerX.centerY.equalTo(view)
        })
        
        view.backgroundColor = UIColor(r: 0, g: 120, b: 175)
        return view
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
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(r: 149, g: 204, b: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName:UIColor.init(r: 17, g: 154, b: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        setupLogoContainerView()
        setupInputFields()
        setupSignUpButton()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Setup Methods
    
    fileprivate func setupSignUpButton() {
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.height.equalTo(50)
        }
    }
    
    fileprivate func setupLogoContainerView() {
        view.addSubview(logoContainerView)
        logoContainerView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(self.view)
            make.height.equalTo(150)
        }
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(40)
            make.right.equalTo(view).offset(-40)
            make.top.equalTo(logoContainerView.snp.bottom).offset(40)
            make.height.equalTo(140)
        }
    }
    
    
    // MARK: - Handle Methods
    
    func handleShowSignUp() {
        let signupController = SignUpController()
        navigationController?.pushViewController(signupController, animated: true)
    }
    
    func handleTextInputChange() {
        let isFormValid = !(emailTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
        loginButton.backgroundColor = isFormValid ? .mainBlue() : UIColor(r: 149, g: 204, b: 244)
        loginButton.isEnabled = isFormValid ? true : false
    }
    
    func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let err = error {
                print("Failed to sign in with email: ", err)
                return
            }
            print("Succesfully logged back in with user")
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        })
    }
}
