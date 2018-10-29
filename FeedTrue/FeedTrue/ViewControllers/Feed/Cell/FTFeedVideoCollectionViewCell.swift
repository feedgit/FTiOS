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
    func videoCellDidChangeReactionType(cell: FTFeedVideoCollectionViewCell)
    func videoCellDidRemoveReaction(cell: FTFeedVideoCollectionViewCell)
    
    // saved
    func videoCellDidSaved(cell: FTFeedVideoCollectionViewCell)
    func videoCellDidUnSaved(cell: FTFeedVideoCollectionViewCell)
}
class FTFeedVideoCollectionViewCell: UICollectionViewCell {

    weak var delegate: VideoCellDelegate?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var reactionButton: ReactionButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var ftReactionType: FTReactionTypes = .love
    var contetnData: FTFeedVideoContent?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFill
        
        reactionButton.reactionSelector = ReactionSelector()
        reactionButton.config           = ReactionButtonConfig() {
            $0.iconMarging      = 8
            $0.spacing          = 0
            $0.font             = UIFont(name: "HelveticaNeue", size: 0)
            $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
            $0.alignment        = .centerLeft
        }
        
        reactionButton.reactionSelector?.feedbackDelegate = self
    }
    
    func render(content: FTFeedVideoContent) {
        contetnData = content
        contentLabel.text = content.title.htmlToString
        // video content
        imageView.loadImage(fromURL: URL(string: content.thumbnail), defaultImage: UIImage.noImage())
        
        // config react icon
        switch content.request_reacted {
        case "LOVE":
            ftReactionType = .love
            reactionButton.reaction   = Reaction.facebook.like
        case "LAUGH":
            ftReactionType = .laugh
            reactionButton.reaction   = Reaction.facebook.laugh
        case "WOW":
            ftReactionType = .wow
            reactionButton.reaction   = Reaction.facebook.wow
        case "SAD":
            ftReactionType = .sad
            reactionButton.reaction   = Reaction.facebook.sad
        case "ANGRY":
            ftReactionType = .angry
            reactionButton.reaction   = Reaction.facebook.angry
        default:
            ftReactionType = .love
            reactionButton.reaction   = Reaction.facebook.like
        }
        
        // config save icon
        if content.saved {
            // icon saved
            self.saveBtn.setImage(UIImage(named: "saved"), for: .normal)
        } else {
            // icon save
            self.saveBtn.setImage(UIImage(named: "save"), for: .normal)
        }
    }
    @IBAction func commentBtnTouchUpAction(_ sender: Any) {
        
    }
    @IBAction func saveBtnTouchUpAction(_ sender: Any) {
        if let saved = contetnData?.saved {
            if saved {
                self.delegate?.videoCellDidUnSaved(cell: self)
                self.saveBtn.setImage(UIImage(named: "save"), for: .normal)
                self.contetnData?.saved = false
                return
            }
        }
        self.saveBtn.setImage(UIImage(named: "saved"), for: .normal)
        self.contetnData?.saved = true
        self.delegate?.videoCellDidSaved(cell: self)
    }
    
    @IBAction func reactButtonTouchUpAction(_ sender: Any) {
        reactionButton.reaction   = Reaction.facebook.like
        ftReactionType = .love
        if reactionButton.isSelected == false {
            self.delegate?.videoCellDidRemoveReaction(cell: self)
        } else {
            self.delegate?.videoCellDidChangeReactionType(cell: self)
        }
    }
}

extension FTFeedVideoCollectionViewCell: ReactionFeedbackDelegate {
    func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
        guard let reaction = reactionButton.reactionSelector?.selectedReaction else { return }
        NSLog("\(#function) selected: \(reaction.title)")
        switch reaction.title {
        case "like":
            ftReactionType = .love
        case "laugh":
            ftReactionType = .laugh
        case "wow":
            ftReactionType = .wow
        case "sad":
            ftReactionType = .sad
        case "angry":
            ftReactionType = .angry
        default:
            ftReactionType = .love
        }
        self.delegate?.videoCellDidChangeReactionType(cell: self)
    }
}
