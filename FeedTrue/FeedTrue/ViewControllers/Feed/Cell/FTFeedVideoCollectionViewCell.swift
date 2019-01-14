//
//  FTFeedVideoCollectionViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

@objc protocol VideoCellDelegate {
    // reaction
//    func videoCellDidChangeReactionType(cell: FTFeedVideoCollectionViewCell)
//    func videoCellDidRemoveReaction(cell: FTFeedVideoCollectionViewCell)
    
    // saved
    func videoCellDidSaved(cell: FTFeedVideoCollectionViewCell)
    func videoCellDidUnSaved(cell: FTFeedVideoCollectionViewCell)
}
class FTFeedVideoCollectionViewCell: UICollectionViewCell {

    weak var delegate: VideoCellDelegate?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    var contetnData: FTFeedVideoContent?
    @IBOutlet weak var lovedLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 8
        avatarImage.round()
        self.layer.masksToBounds = true
    }
    
    func render(content: FTFeedVideoContent) {
        contetnData = content
        contentLabel.text = content.title.htmlToString
        // Render LovedLabel
        let LovedLabelString = NSMutableAttributedString(string: "")
        let spaced = NSMutableAttributedString(string: " ")
        let loved_stats = content.reactions?.count ?? 0
        if (loved_stats > 0) {
            let ic_loved = NSTextAttachment()
            ic_loved.image = UIImage(named: "love_filled")
            let imageOffsetY:CGFloat = -5.0
            ic_loved.bounds = CGRect(x: 0, y: imageOffsetY, width: 15, height: 15)
            let attachmentString = NSAttributedString(attachment: ic_loved)
            LovedLabelString.append(attachmentString)
            let textAfterIcon = NSMutableAttributedString(string: String(loved_stats))
            LovedLabelString.append(textAfterIcon)
        }
        // Render ViewedLabel
        let viewed_stats = content.views
        if (viewed_stats > 0) {
            LovedLabelString.append(spaced)
            let viewed_icon = NSMutableAttributedString(string: "▶")
            let viewed_string = NSMutableAttributedString(string: String(viewed_stats))
            LovedLabelString.append(viewed_icon)
            LovedLabelString.append(viewed_string)
        }
        lovedLabel.attributedText = LovedLabelString
        avatarImage.loadImage(fromURL: URL(string: content.user?.avatar ?? ""), defaultImage: UIImage.userImage())
        // video content
        durationLabel.text = content.duration
        imageView.loadImage(fromURL: URL(string: content.thumbnail), defaultImage: UIImage.noImage())
    }
}
