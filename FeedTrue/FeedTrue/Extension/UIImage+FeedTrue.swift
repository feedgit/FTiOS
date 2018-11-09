//
//  UIImage+FeedTrue.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/24/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import AVFoundation

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
        return UIImage(named: "ic_noimage")
    }
    
    class func userImage() -> UIImage? {
        return UIImage(named: "ic_user")
    }
    
    class func noImage() -> UIImage {
        return UIImage(named: "ic_noimage")!
    }
    
    class func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
            
        }
        
    }
}
