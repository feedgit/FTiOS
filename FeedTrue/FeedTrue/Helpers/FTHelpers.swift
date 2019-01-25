//
//  FTHelpers.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/14/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

struct FTHelpers {
    
    static func attributeString (imageNamed: String, str: String, attrs: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {
        return attributeString(image: UIImage(named: imageNamed)!, str: str, attrs: attrs)
    }
    
    static func attributeString (imageNamed: String, str: String, attrs: [NSAttributedString.Key: Any]? = nil, offset: Float = 2) -> NSAttributedString {
        return attributeString(image: UIImage(named: imageNamed)!, str: str, attrs: attrs, offset: offset)
    }
    
    static func attributeString (image: UIImage, str: String, attrs:[NSAttributedString.Key: Any]?, offset: Float = 2, fontDescender: CGFloat = 0) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        let attString = NSMutableAttributedString(string: "")
        attachment.bounds = CGRect(x: 0.0, y: fontDescender, width: attachment.image!.size.width, height: attachment.image!.size.height)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        attString.append(attachmentString)
        
        var textAttrs = attrs ?? [:]
        textAttrs[NSAttributedString.Key.baselineOffset] = NSNumber(value: offset)
        let rightText = NSAttributedString(string: "  \(str)", attributes: textAttrs)
        attString.append(rightText)
        return attString
    }
    
    static func imageResize(image: UIImage, size: CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
    static func sizeForText(_ text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        if maxWidth < 0 || text == "" {
            return CGSize(width: 0, height: 0)
        }
        
        let nstest = text as NSString
        let textsize = nstest.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin) , attributes:[NSAttributedString.Key.font: font], context: nil)
        
        //round up
        let doubleWdith = ceil(textsize.size.width * 2)
        let doubleHeight = ceil(textsize.size.height * 2)
        let result = CGSize(width: doubleWdith * 0.5, height: doubleHeight * 0.5)
        
        return result
    }
    
    static func AIPRelativeDateFormatter() -> DateFormatter
    {
        var relativeDateFormatter: DateFormatter
        relativeDateFormatter = DateFormatter()
        relativeDateFormatter.dateStyle = .short;
        relativeDateFormatter.doesRelativeDateFormatting = true
        return relativeDateFormatter
    }
    
    static func AIPShortTimeFormatter() -> DateFormatter
    {
        var shortTimeFormatter: DateFormatter
        shortTimeFormatter = DateFormatter()
        shortTimeFormatter.timeStyle = .short
        return shortTimeFormatter
    }
    
    
    static func attributedStringIcon(_ icon: UIImage?) -> NSAttributedString{
        let attachment = NSTextAttachment()
        attachment.image = icon
        let attachmentString = NSAttributedString(attachment: attachment)
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append(attachmentString)
        return attributedString
    }
    
    static func secondsToHoursMinutesSeconds (_ seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func secondsToHoursMinutesSeconds (_ seconds : Int) -> String {
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds)
        let format = "%02d"
        if h > 0 {
            return String(format: format, h) + ":" + String(format: format, m) + ":" + String(format: format, s)
        }
        
        return String(format: format, m) + ":" + String(format: format, s)
    }
    
    static func scrollToTop(_ tableView: UITableView) {
        tableView.contentOffset = CGPoint(x: 0, y: -tableView.contentInset.top)
    }
    
    static func loadGroupAvatar(avatarId: String) -> UIImage? {
        let cacheURLString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let path = cacheURLString.appending("/GroupAvatars/\(avatarId)")
        
        return UIImage(contentsOfFile: path)
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio,height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func textViewHeigh(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let calculationView = UITextView()
        calculationView.font = font
        calculationView.text = text
        let size = calculationView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        return size.height
    }
}
