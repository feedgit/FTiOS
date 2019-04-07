//
//  FTCommentTextCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/6/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import SwiftMoment

@objc protocol FTCommentTextCellDelegate {
    func commentCellDidChangeReactionType(cell: FTCommentTextCell)
    func commentCellDidRemoveReaction(cell: FTCommentTextCell)
}
class FTCommentTextCell: UITableViewCell, BECellRenderImpl {
    
    weak var delegate: FTCommentTextCellDelegate?
    typealias CellData = FTCommentViewModel
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var paddingLeftLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var reactionButton: ReactionButton!
    var ftReactionType: FTReactionTypes = .love
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.round()
        self.selectionStyle = .none
        
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var contentData: FTCommentViewModel?
    func renderCell(data: FTCommentViewModel) {
        contentData = data
        if let urlString = data.comment.user?.avatar {
            if let url = URL(string: urlString) {
                self.avatarImageView.loadImage(fromURL: url, defaultImage: UIImage.userImage())
            } else {
                self.avatarImageView.image = UIImage.userImage()
            }
        } else {
            self.avatarImageView.image = UIImage.userImage()
        }
        let lastname = data.comment.user?.last_name ?? ""
        let lastnameAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
        let lastnameAttrString = NSAttributedString(string: lastname, attributes: lastnameAttribute)
        
        let content = data.comment.comment?.htmlToString ?? ""
        let contentAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
        let contentAttrString = NSAttributedString(string: content, attributes: contentAttribute)
        
        let attString = NSMutableAttributedString(attributedString: lastnameAttrString)
        attString.append(NSAttributedString(string: " "))
        attString.append(contentAttrString)

        //contentLabel.text = "\(lastname) \(data.comment.comment?.htmlToString ?? "")"
        contentLabel.attributedText = attString
        if let post_on = data.comment.posted_on {
            dateLabel.text = moment(post_on, timeZone: TimeZone(secondsFromGMT: 0)!, locale: .current)?.fromNowFT()
        } else {
            dateLabel.text = nil
        }
        
        paddingLeftLayoutConstraint.constant = 8
        // config react icon
        if let reactType = data.comment.request_reacted {
            switch reactType {
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
        }
    }
    
    @IBAction func replyTouchUpAction(_ sender: Any) {
        contentData?.reply?(contentData)
    }
    
    @IBAction func reactionButtonTouchUpAction(_ sender: Any) {
        reactionButton.reaction   = Reaction.facebook.like
        ftReactionType = .love
        if reactionButton.isSelected == false {
            self.delegate?.commentCellDidRemoveReaction(cell: self)
        } else {
            self.delegate?.commentCellDidChangeReactionType(cell: self)
        }
    }
    
    
    @IBAction func moreBtnTouchUpAction(_ sender: Any) {
        contentData?.more?(contentData)
    }
    
}

extension FTCommentTextCell: ReactionFeedbackDelegate {
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
        
        self.delegate?.commentCellDidChangeReactionType(cell: self)
    }
}
