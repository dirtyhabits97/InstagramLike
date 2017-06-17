//
//  CommentsController.swift
//  InstagramLike
//
//  Created by GERH on 6/16/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class CommentsController: UICollectionViewController {
    
    // MARK: - Object Ids
    private let cellId = "cellId"
    
    // MARK: - Object Variables
    var post: Post?
    var comments = [Comment]()
    
    // MARK: - CommentsController Properties
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    // MARK: - Interface Objects
    var width: CGFloat?
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: self.width!, height: 50)
        
        let submitButon = UIButton(type: .system)
        submitButon.setTitle("Submit", for: .normal)
        submitButon.setTitleColor(.black, for: .normal)
        submitButon.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButon.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        
        containerView.addSubview(submitButon)
        containerView.addSubview(self.commentTextField)
        containerView.addSubview(separatorView)
        submitButon.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(containerView)
            make.right.equalTo(containerView.snp.right).offset(-12)
            make.width.equalTo(50)
        }
        self.commentTextField.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(containerView)
            make.right.equalTo(submitButon.snp.left).offset(-4)
            make.left.equalTo(containerView).offset(12)
        }
        separatorView.snp.makeConstraints({ (make) in
            make.right.left.top.equalTo(containerView)
            make.height.equalTo(1)
        })
        
        return containerView
    }()
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()

    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        width = view.frame.width
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Comments"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        registerCells()
        fetchComments()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        resignFirstResponder()
    }
    
    
    // MARK: - Setup Methods
    
    fileprivate func registerCells() {
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // MARK: - Handle Methods
    
    func handleSubmit() {
        guard let postId = post?.id else { return }
        guard let uid = post?.user.uid else { return }
        let values = ["text" : commentTextField.text ?? "", "creationDate" : Date().timeIntervalSince1970, "uid" : uid] as [String : Any]
        FIRDatabase.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, ref) in
            if let err = error {
                print("Failed to insert comment to database: ", err)
                return
            }
        }
        print("Succesfully saved comment to database")
    }
    
    // MARK: - Fetch Methods
    
    fileprivate func fetchComments() {
        guard let postId = post?.id else { return }
        let reference = FIRDatabase.database().reference().child("comments").child(postId)
        reference.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            FIRDatabase.fetchUser(withUID: uid, completion: { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
        }) { (error) in
            print("Failed to fetch comments: ", error)
        }
    }
    
    // MARK: - CollectionView Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        return cell
    }
}


// MARK: - FlowLayoutDelegate Methods

extension CommentsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    // space between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
