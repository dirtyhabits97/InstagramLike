//
//  Protocols.swift
//  InstagramLike
//
//  Created by GERH on 6/16/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

protocol HomePostCellDelegate: class {
    func didTapComment(post: Post)
    func didLike(for cell: HomePostCell)
}

protocol UserProfileHeaderDelegate: class {
    func didChangeToListView()
    func didChangeToGridView()
}
