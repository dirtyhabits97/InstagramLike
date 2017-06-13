//
//  UserSearchController.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/12/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class UserSearchController: UICollectionViewController {
    
    
    // MARK: - Object Ids
    private let cellId = "cellId"
    
    // MARK: - Object Variables
    var users = [User]()
    var filteredUsers = [User]()
    
    // MARK: - Interface Objects
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.delegate = self
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
        fetchUsers()
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
    
    
    // MARK: - Fetch Methods
    
    fileprivate func fetchUsers() {
        let ref = FIRDatabase.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String:Any] else { return }
                let user = User(uid: key, dictionary: dictionary)
                self.users.append(user)
            })
//            self.users.sort{ $0.username.compare($1.username) == .orderedAscending }
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch users for search")
        }
    }
    
    
    // MARK: -  CollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        
        return cell
    }
}


// MARK: - FlowLayoutDelegate Methods

extension UserSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
}


// MARK: - SearchBarDelegate Methods

extension UserSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
}
