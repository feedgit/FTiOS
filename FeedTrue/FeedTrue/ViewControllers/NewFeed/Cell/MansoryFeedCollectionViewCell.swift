//
//  MansoryFeedCollectionViewCell.swift
//  FeedTrue
//
//  Created by Le Cong Toan on 4/11/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class MansoryFeedCollectionViewCell: UICollectionViewCell {
    
    var feed: FTFeedInfo!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var thumb_img: UIImageView!
    public enum FeedDisplayType: String {
        case photoset = "photoset"
        case singleVideo = "single-video"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        text.isEditable = false
        thumb_img.layer.cornerRadius = 10
        thumb_img.layer.masksToBounds = true
    }
    
    func renderCell(data: FTFeedViewModel) {
        feed = data.feed
        self.text.text = feed.text
        if let type = feed.feedcontent?.type {
            guard let imageDatas = feed.feedcontent?.data else { return }
            switch type {
            case FeedDisplayType.photoset.rawValue:
                let image = imageDatas[0]
                guard let imageDict = image["file"] as? [String: Any] else { return }
                guard let url = imageDict["src"] as? String else { return }
                thumb_img.loadImage(fromURL: URL(string: url), defaultImage: UIImage.noImage())
            default:
                break
            }
            
        }
    }

}
