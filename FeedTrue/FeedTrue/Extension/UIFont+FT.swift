//
//  UIFont+FT.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/29/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

extension UIFont {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func swipeMenuFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "HelveticaNeue", size: size)
    }
    
    static func ArticleTitleFont() -> UIFont {
        return customFont(name: "HelveticaNeue-Bold", size: 22)
    }
}
