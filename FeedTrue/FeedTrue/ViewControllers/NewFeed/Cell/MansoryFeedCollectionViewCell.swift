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
    @IBOutlet weak var thumb_img: UIImageView!
    @IBOutlet weak var feedTextLbl: UILabel!
    @IBOutlet weak var UserAvatarView: UIImageView!
    @IBOutlet weak var UserUsername: UILabel!
    @IBOutlet weak var feedViewLbl: UILabel!
    @IBOutlet weak var feedLovesLbl: UILabel!
    public enum FeedDisplayType: String {
        case photoset = "photoset"
        case singleVideo = "single-video"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        feedTextLbl.lineBreakMode = .byWordWrapping
        feedTextLbl.numberOfLines = 2
        feedTextLbl.font = feedTextLbl.font.withSize(14)
        UserUsername.font = UserUsername.font.withSize(13)
        feedViewLbl.font = feedViewLbl.font.withSize(11)
        feedLovesLbl.font = feedLovesLbl.font.withSize(11)
        thumb_img.layer.cornerRadius = 10
        thumb_img.layer.masksToBounds = true
        UserAvatarView.round()
    }
    
    override func prepareForReuse() {
        feedTextLbl.text = ""
        thumb_img.image = nil
        UserUsername.text = ""
        UserAvatarView.image = nil
        feedViewLbl.text = ""
        feedLovesLbl.text = ""
    }
    
    func renderViewString () {
        let feedviewString = NSMutableAttributedString(string: "")
        let spaced = NSMutableAttributedString(string: " ")
        let feedViewCount = feed.views
        if (feedViewCount > 0) {
            let ic_view = NSTextAttachment()
            ic_view.image = UIImage(named: "view")
            let imageOffsetY:CGFloat = -5.0
            ic_view.bounds = CGRect(x: 0, y: imageOffsetY, width: 15, height: 15)
            let attachmentString = NSAttributedString(attachment: ic_view)
            feedviewString.append(attachmentString)
            feedviewString.append(spaced)
            let textAfterIcon = NSMutableAttributedString(string: String("\(feedViewCount ?? 0)"))
            feedviewString.append(textAfterIcon)
            feedViewLbl.attributedText = feedviewString
        }
    }
    
    func renderCell(data: FTFeedViewModel) {
        feed = data.feed
        self.feedTextLbl.text = feed.text?.htmlToString ?? ""
        if let urlString = feed.user?.avatar {
            if let url = URL(string: urlString) {
                self.UserAvatarView.loadImage(fromURL: url, defaultImage: UIImage.userImage())
            } else {
                self.UserAvatarView.image = UIImage.userImage()
            }
        } else {
            self.UserAvatarView.image = UIImage.userImage()
        }
        renderViewString()
        feedLovesLbl.text = "\(feed.loves ?? 0)"
        UserUsername.text = feed.user?.username
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
