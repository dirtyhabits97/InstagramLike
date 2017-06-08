//
//  LoginController.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/7/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit

class LoginController: UIViewController {
    
    // MARK: - Interface Objects
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account?   Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        setupSignUpButton()
    }
    
    
    // MARK: - Setup Methods
    
    fileprivate func setupSignUpButton() {
        view.addSubview(signupButton)
        signupButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.height.equalTo(50)
        }
    }
    
    
    // MARK: - Handle Methods
    
    func handleShowSignUp() {
        let signupController = SignUpController()
        navigationController?.pushViewController(signupController, animated: true)
    }
}
