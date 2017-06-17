//
//  Comment.swift
//  InstagramLike
//
//  Created by GERH on 6/16/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

struct Comment {
    let creationDate: Date
    let text: String
    let uid: String
//    let post: Post
    
    init(/*post: Post,*/dictionary: [String:Any]) {
//        self.post = post
        self.uid = dictionary["uid"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
