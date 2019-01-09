//
//  FTAriticleTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/19/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import SwiftMoment

@objc protocol FTAticleCellDelegate {
    func articleCellDidChangeReaction(cell: FTAriticleTableViewCell)
    func articleCellDidRemoveReaction(cell: FTAriticleTableViewCell)
    func articleCellDidTouchComment(cell: FTAriticleTableViewCell)
    func articleCellDidSave(cell: FTAriticleTableViewCell)
    func articleCellDidUnSave(cell: FTAriticleTableViewCell)
}

class FTAriticleTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTAriticleViewModel
    var article: FTArticleContent!
    var ftReactionType: FTReactionTypes = .love
    weak var delegate: FTAticleCellDelegate?
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var loveLabel: UILabel!
    @IBOutlet weak var reactionButton: ReactionButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var savedBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.round()
        
        reactionButton.reactionSelector = ReactionSelector()
        reactionButton.config           = ReactionButtonConfig() {
            $0.iconMarging      = 10
            $0.spacing          = 0
            $0.font             = UIFont(name: "HelveticaNeue", size: 0)
            $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
            $0.alignment        = .centerLeft
        }
        
        reactionButton.reactionSelector?.feedbackDelegate = self
        self.selectionStyle = .none
    }
    
    func renderCell(data: FTAriticleViewModel) {
        article = data.article
        thumbImageView.loadImage(fromURL: URL(string: article.thumbnail), defaultImage: UIImage.noImage())
        titleLabel.text = article.title
        contentLabel.text = article.description
        userImageView.loadImage(fromURL: URL(string: article.user?.avatar ?? ""), defaultImage: UIImage.userImage())
        timeLabel.text = moment(article.create_date, timeZone: TimeZone(secondsFromGMT: 0)!, locale: .current)?.fromNowFT()
        if let reactionCount = article.reactions?.count, reactionCount > 0 {
            loveLabel.text = "\(reactionCount)"
        } else {
            loveLabel.text = nil
        }
        
        if let commentCount = article.comments?.count, commentCount > 0 {
            commentLabel.text = "\(commentCount)"
        } else {
            commentLabel.text = nil
        }
        
        switch article.request_reacted {
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
        if article.saved {
            // icon saved
            savedBtn.setImage(UIImage(named: "saved"), for: .normal)
        } else {
            // icon save
            savedBtn.setImage(UIImage(named: "save"), for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    
    @IBAction func replyTouchUpAction(_ sender: Any) {
        
    }
    
    @IBAction func commentTouchUpAction(_ sender: Any) {
        self.delegate?.articleCellDidTouchComment(cell: self)
    }
    
    @IBAction func saveTouchUpAction(_ sender: Any) {
        if article.saved {
            self.delegate?.articleCellDidUnSave(cell: self)
            self.savedBtn.setImage(UIImage(named: "save"), for: .normal)
            self.article.saved = false
            return
        }
        self.savedBtn.setImage(UIImage(named: "saved"), for: .normal)
        self.article.saved = true
        self.delegate?.articleCellDidSave(cell: self)
    }
    
    @IBAction func reactionButtonTouchUpAction(_ sender: Any) {
        reactionButton.reaction   = Reaction.facebook.like
        ftReactionType = .love
        if reactionButton.isSelected == false {
            self.delegate?.articleCellDidRemoveReaction(cell: self)
        } else {
            self.delegate?.articleCellDidChangeReaction(cell: self)
        }
    }
}

extension FTAriticleTableViewCell: ReactionFeedbackDelegate {
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
        self.delegate?.articleCellDidChangeReaction(cell: self)
    }
}
