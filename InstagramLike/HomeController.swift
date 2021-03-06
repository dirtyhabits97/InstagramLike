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
    let refreshControl = UIRefreshControl()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
        collectionView?.backgroundColor = .white
        setupRefreshController()
        setupNavigationItems()
        registerCells()
        fetchAllPosts()
    }
    
    
    // MARK: - Setup Methods
    fileprivate func setupObserver() {
        let name = SharePhotoController.updateFeedNotificationName
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: name, object: nil)
    }
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    fileprivate func registerCells() {
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
    }
    fileprivate func setupRefreshController() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    
    // MARK: - Handle Methods
    
    func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    func handleUpdateFeed() {
        handleRefresh()
    }
    func handleCamera() {
        let cameraController = CameraController()
        present(cameraController, animated: true)
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
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String:Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                
                guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
                FIRDatabase.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snap) in
                    if let like = snap.value as? Int, like == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    
                    
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (err) in
                    print("Failed to fetch like: ", err)
                })
            })
        }) { (error) in
            print("Failed to fetch posts: ", error)
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
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    // MARK: - CollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        if !self.refreshControl.isRefreshing {
            cell.post = posts[indexPath.item]
        }
        cell.delegate = self
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


// MARK: - HomePostCellDelegate Methods

extension HomeController: HomePostCellDelegate {
    func didTapComment(post: Post) {
        print("didTapComment")
        let commentController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        navigationController?.pushViewController(commentController, animated: true)
    }
    func didLike(for cell: HomePostCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var post = posts[indexPath.item]
        guard let postId = post.id else { return }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let values = [uid:post.hasLiked == true ? 0 : 1]
        FIRDatabase.database().reference().child("likes").child(postId).updateChildValues(values) { (error, ref) in
            if let err = error {
                print("Failed to like post", err)
                return
            }
            print("Succesfully liked post")
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }
}
