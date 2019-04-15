//
//  FTTagViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

@objc protocol VideoCellDelegate {
    // reaction
//    func videoCellDidChangeReactionType(cell: FTTagViewCell)
//    func videoCellDidRemoveReaction(cell: FTTagViewCell)
    
    // saved
    func videoCellDidSaved(cell: FTTagViewCell)
    func videoCellDidUnSaved(cell: FTTagViewCell)
}
class FTTagViewCell: UICollectionViewCell {

    weak var delegate: VideoCellDelegate?
    @IBOutlet weak var imageView: UIImageView!
    var contetnData: TagExploreContent?
    @IBOutlet weak var lovedLabel: UILabel!
    @IBOutlet weak var tagNameLbl: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        tagNameLbl.textContainer.maximumNumberOfLines = 2
        tagNameLbl.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    override func prepareForReuse() {
        tagNameLbl.text = ""
        imageView.image = nil
    }
    
    func render(content: TagExploreContent) {
        contetnData = content
        tagNameLbl.text = content.name
        // Render LovedLabel
        let LovedLabelString = NSMutableAttributedString(string: "")
        let spaced = NSMutableAttributedString(string: " ")
        let loved_stats = content.tagged_count
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
        // video content
        imageView.loadImage(fromURL: URL(string: content.thumbnail), defaultImage: UIImage.noImage())
    }
}
