//
//  UIImage+FeedTrue.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/24/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        
        self.init(cgImage: cgImage)
    }
    
    class func defaultImage() -> UIImage? {
        return UIImage(named: "1000x1000")
    }
}
