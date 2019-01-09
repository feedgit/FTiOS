//
//  UIColor+FeedTrue.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/28/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

extension UIColor {
    class func genderSelectedColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(rgb: 0x009BD6).withAlphaComponent(alpha)
    }
    
    class func genderUnselectedColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.black.withAlphaComponent(alpha)
    }
    
    class func navigationBarColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.white.withAlphaComponent(alpha)
    }
    
    class func navigationTitleTextColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.black.withAlphaComponent(alpha)
    }
    
    class func backgroundColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(rgb: 0xF6F6F6).withAlphaComponent(alpha)
    }
    
    class func videoVCBackGroundCollor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hex: 0xdedede).withAlphaComponent(alpha)
    }
    
    class func topLineBackGround(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hex: 0xf9f9f9).withAlphaComponent(alpha)
    }
    
    class func badgeTextColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.white.withAlphaComponent(alpha)
    }
    
    class func mainColor() -> UIColor {
        return UIColor(hex: 0x62e1fb)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
