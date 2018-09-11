//
//  FTFileProviderService.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/10/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTFileProviderService: FTCoreServiceComponent {
    private class FileProviderTask: Hashable, Equatable {
        typealias ImageObject = (imageView: UIImageView, defaultImage: UIImage?)
        var keyObject: [ImageObject]
        var key: String
        var discardable = false
        
        init(object o: ImageObject, key k: String) {
            keyObject = [ImageObject]()
            keyObject.append(o)
            key = k
        }
        
        var hashValue: Int {
            get {
                return keyObject.reduce(0, {$0 & $1.imageView.hashValue}) & key.hashValue
            }
        }
        
        func index(of imageView: UIImageView) -> Int? {
            return keyObject.index(where: {$0.imageView == imageView})
        }
        
        func equal(objects: [ImageObject]) -> Bool {
            guard keyObject.count == objects.count else {
                return false
            }
            
            for i in 0..<keyObject.count {
                let mine = keyObject[i]
                let other = objects[i]
                if mine.imageView != other.imageView {
                    return false
                }
            }
            
            return true
        }
        
        func contains(imageView: UIImageView) -> Bool {
            return keyObject.first(where: {$0.imageView == imageView}) != nil
        }
        
        public static func ==(lhs: FileProviderTask, rhs: FileProviderTask) -> Bool {
            return lhs.equal(objects: rhs.keyObject) && lhs.key == rhs.key
        }
    }
    
    //private var networkProvider : FileTransferProvider?
    private var imageCache = NSCache<NSString, UIImage>()
    
    func setup() {
        
    }
    

}
