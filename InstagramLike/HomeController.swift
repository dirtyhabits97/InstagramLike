//
//  HomeController.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/12/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
    
    // MARK: - Object Ids
    private let cellId = "cellId"
    
    // MARK: - Object Variables
    var posts = [Post]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        setupNavigationItems()
        registerCells()
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    
    // MARK: - Setup Methods
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    fileprivate func registerCells() {
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    // MARK: - Fetch Methods
    
    fileprivate func fetchPosts() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        FIRDatabase.fetchUser(withUID: uid) { (user) in
            self.fetchPosts(fromUser: user)
        }
    }
    fileprivate func fetchPosts(fromUser user: User) {
        let ref = FIRDatabase.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String:Any] else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            })
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch posts: ", err)
        }
    }
    fileprivate func fetchFollowingUserIds() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let ref = FIRDatabase.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String:Any] else { return }
            userIdsDictionary.forEach({ (key, value) in
                
                FIRDatabase.fetchUser(withUID: key, completion: { (user) in
                    self.fetchPosts(fromUser: user)
                })
                
            })
        }) { (error) in
            print("Failed to fetch followed users: ", error)
        }
    }
    
    // MARK: - CollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
}


// MARK: - FlowLayoutDelegate Methods

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 //usernameLabel and userProfileImageView and offset from top
        height += 8 // offset between top and post photo
        height += view.frame.width //square picture for the post
        height += 50
        height += 80 // extra height for the caption
        return CGSize(width: view.frame.width, height: height)
    }
}
