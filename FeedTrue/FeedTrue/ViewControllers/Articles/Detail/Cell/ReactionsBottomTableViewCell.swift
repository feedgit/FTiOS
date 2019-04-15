//
//  ReactionsBottomTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/10/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class ReactionsBottomTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = ArticleReactionViewModel
    
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var reactionButton: ReactionButton!
    @IBOutlet weak var reactionLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    
    var ftReactionType: FTReactionTypes = .love
    var article: FTArticleContent!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reactionButton.reactionSelector = ReactionSelector()
        reactionButton.config           = ReactionButtonConfig() {
            $0.iconMarging      = 0
            $0.spacing          = 0
            $0.font             = UIFont(name: "HelveticaNeue", size: 0)
            $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
            $0.alignment        = .centerLeft
        }
        
        reactionButton.reactionSelector?.feedbackDelegate = self
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: ArticleReactionViewModel) {
        article = data.article
        
        if let reactionCount = article.loves, reactionCount > 0 {
            reactionLabel.text = "\(reactionCount)"
        } else {
            reactionLabel.text = nil
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
    }
    
    @IBAction func reactionButtonTouchUpAction(_ sender: Any) {
        reactionButton.reaction   = Reaction.facebook.like
        ftReactionType = .love
        if reactionButton.isSelected == false {
            //self.delegate?.articleCellDidRemoveReaction(cell: self)
        } else {
            //self.delegate?.articleCellDidChangeReaction(cell: self)
        }
    }
    
}

extension ReactionsBottomTableViewCell: ReactionFeedbackDelegate {
    func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
        
    }
}
