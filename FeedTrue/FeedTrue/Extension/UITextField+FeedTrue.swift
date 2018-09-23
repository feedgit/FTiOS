//
//  UITextField+FeedTrue.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/23/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

extension UITextField {
    func defaultBorder() {
        self.borderStyle = .none
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
}
