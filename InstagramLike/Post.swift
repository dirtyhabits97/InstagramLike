//
//  Post.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/12/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    init(dictionary: [String:Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
