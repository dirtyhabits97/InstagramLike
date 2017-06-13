//
//  FirebaseUtils.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/12/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation
import Firebase

extension FIRDatabase {
    static func fetchUser(withUID uid: String, completion: @escaping (User)->()) {
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }, withCancel: { (err) in
            print("Failed to fetch user: ", err)
        })
    }
}
