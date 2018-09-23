//
//  UIButton+FeedTrue.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/7/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

extension UIButton {
    func defaultBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
}
