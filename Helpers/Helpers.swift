//
//  Helpers.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/5/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g:CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
