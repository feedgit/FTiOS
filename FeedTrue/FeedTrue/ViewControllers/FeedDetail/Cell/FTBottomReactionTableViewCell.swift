//
//  FTBottomReactionTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTBottomReactionTableViewCell: UITableViewCell, BECellRenderImpl {
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var reactionButton: ReactionButton!
    @IBOutlet weak var commentBtn: UIButton!
    typealias CellData = FTBottomReactionViewModel
    var contentData: FTBottomReactionViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        lineView.backgroundColor = UIColor.videoVCBackGroundCollor()
        reactionButton.reactionSelector = ReactionSelector()
        reactionButton.config           = ReactionButtonConfig() {
            $0.iconMarging      = 10
            $0.spacing          = 0
            $0.font             = UIFont(name: "HelveticaNeue", size: 0)
            $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
            $0.alignment        = .centerLeft
        }
        
        reactionButton.reactionSelector?.feedbackDelegate = self
    }
    
    @IBAction func reactionButtonTouchUpAction(_ sender: Any) {
        reactionButton.reaction   = Reaction.facebook.like
        contentData?.ftReactionType = .love
        if reactionButton.isSelected == false {
            //self.delegate?.feedCellDidRemoveReaction(cell: self)
        } else {
            //self.delegate?.feedCellDidChangeReactionType(cell: self)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: FTBottomReactionViewModel) {
        contentData = data
    }
    
}

extension FTBottomReactionTableViewCell: ReactionFeedbackDelegate {
    func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
        guard let reaction = reactionButton.reactionSelector?.selectedReaction else { return }
        
        NSLog("\(#function) selected: \(reaction.title)")
        switch reaction.title {
        case "like":
            contentData?.ftReactionType = .love
        case "laugh":
            contentData?.ftReactionType = .laugh
        case "wow":
            contentData?.ftReactionType = .wow
        case "sad":
            contentData?.ftReactionType = .sad
        case "angry":
            contentData?.ftReactionType = .angry
        default:
            contentData?.ftReactionType = .love
        }
        //self.delegate?.feedCellDidChangeReactionType(cell: self)
    }
}
