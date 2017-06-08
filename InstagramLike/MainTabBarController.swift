//
//  MainTabBarController.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/7/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .black
        let flowLayout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: flowLayout)
        let navController = UINavigationController(rootViewController: userProfileController)
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        viewControllers = [navController]
    }
}
