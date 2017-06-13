//
//  UserSearchController.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/12/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit

class UserSearchController: UICollectionViewController {
    
    // MARK: - Object Ids
    private let cellId = "cellId"
    
    // MARK: - Interface Objects
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        // set the backgorund color for the text field
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(r: 230, g: 230, b: 230)
        return sb
    }()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        setupNavSearchBar()
        registerCells()
    }
    
    
    // MARK: - Setup Methods
    
    fileprivate func setupNavSearchBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(navBar)
            make.right.equalTo(navBar).offset(-8)
            make.left.equalTo(navBar).offset(8)
        }
    }
    fileprivate func registerCells() {
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    // MARK: -  CollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        return cell
    }
}


// MARK: - FlowLayoutDelegate Methods

extension UserSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
}
