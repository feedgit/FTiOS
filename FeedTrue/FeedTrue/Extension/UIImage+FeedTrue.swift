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
        return UIImage.noImage()
    }
    
    class func userImage() -> UIImage? {
        return UIImage(named: "anonymous_avatar")
    }
    
    class func noImage() -> UIImage {
        return UIImage(color: UIColor.videoVCBackGroundCollor())!//UIImage(named: "anonymous_avatar")!
    }
    
    class func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
            
        }
        
    }

    class func saveImage() -> UIImage? {
        return UIImage(named: "save")
    }
    
    class func savedImage() -> UIImage? {
        return UIImage(named: "saved")
    }
    
    class func commentImage() -> UIImage? {
        return UIImage(named: "comment")
    }
    
    class func loveImage() -> UIImage? {
        return UIImage(named: "love")
    }
    
    class func lovedImage() -> UIImage? {
        return UIImage(named: "like")
    }
    
    class func angryImage() -> UIImage? {
        return UIImage(named: "angry")
    }
    
    class func laughImage() -> UIImage? {
        return UIImage(named: "laugh")
    }
    
    class func sadImage() -> UIImage? {
        return UIImage(named: "sad")
    }
    
    class func wowImage() -> UIImage? {
        return UIImage(named: "wow")
    }
}
