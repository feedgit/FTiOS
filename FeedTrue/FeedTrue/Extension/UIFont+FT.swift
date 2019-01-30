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
    
    static func TimestampFont() -> UIFont {
        return customFont(name: "HelveticaNeue-Thin", size: 13)
    }
    
    static func UserNameBlueFont() -> UIFont {
        return customFont(name: "HelveticaNeue-Bold", size: 16)
    }
    
    static func contentFont() -> UIFont {
        return customFont(name: "HelveticaNeue", size: 18)
    }
    
    static func countLabelFont() -> UIFont {
        return customFont(name: "HelveticaNeue-Italic", size: 15)
    }
    
    static func navFont() -> UIFont {
        return customFont(name: "HelveticaNeue-Bold", size: 25)
    }
    
    static func UserNameFont() -> UIFont {
        return customFont(name: "HelveticaNeue-Bold", size: 16)
    }
}
