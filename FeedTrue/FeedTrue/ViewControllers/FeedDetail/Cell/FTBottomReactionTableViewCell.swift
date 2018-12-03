//
//  FTBottomReactionTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

@objc protocol BottomReactionCellDelegate {
    func reactionDidChange(cell: FTBottomReactionTableViewCell)
    func reactionDidRemove(cell: FTBottomReactionTableViewCell)
    func commentDidTouchUpAction(cell: FTBottomReactionTableViewCell)
    func reactionDidSave(cell: FTBottomReactionTableViewCell)
    func reationDidUnSave(cell: FTBottomReactionTableViewCell)
}

class FTBottomReactionTableViewCell: UITableViewCell, BECellRenderImpl {
    weak var delegate: BottomReactionCellDelegate?
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var reactionButton: ReactionButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    typealias CellData = FTBottomReactionViewModel
    var contentData: FTBottomReactionViewModel?
    var ftReactionType: FTReactionTypes = .love
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        lineView.backgroundColor = UIColor.videoVCBackGroundCollor()
        reactionButton.reactionSelector = ReactionSelector()
        reactionButton.config           = ReactionButtonConfig() {
            $0.iconMarging      = 10
            $0.spacing          = 6
            $0.font             = UIFont(name: "HelveticaNeue", size: 20)
            $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
            $0.alignment        = .centerLeft
        }
        
        reactionButton.reactionSelector?.feedbackDelegate = self
        commentBtn.addTarget(self, action: #selector(commentDidTouchUpInside(_:)), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(savedTouchUpAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func reactionButtonTouchUpAction(_ sender: Any) {
        reactionButton.reaction   = Reaction.facebook.like
        contentData?.ftReactionType = .love
        if reactionButton.isSelected == false {
            self.delegate?.reactionDidRemove(cell: self)
        } else {
            self.delegate?.reactionDidChange(cell: self)
        }
    }
    
    @objc func savedTouchUpAction(_ sender: Any) {
        guard let feed = contentData?.feedInfo else { return }
        if let saved = feed.saved {
            if saved {
                self.delegate?.reationDidUnSave(cell: self)
                saveBtn.setImage(UIImage(named: "save"), for: .normal)
                self.contentData?.feedInfo?.saved = false
                return
            }
        }
        saveBtn.setImage(UIImage(named: "saved"), for: .normal)
        self.contentData?.feedInfo?.saved = true
        self.delegate?.reactionDidSave(cell: self)
    }
    
    @objc func commentDidTouchUpInside(_ sender: Any) {
        self.delegate?.commentDidTouchUpAction(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: FTBottomReactionViewModel) {
        contentData = data
        
        if let reactType = contentData?.feedInfo?.request_reacted {
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

        // config save icon
        if let saved = contentData?.feedInfo?.saved {
            if saved {
                // icon saved
                saveBtn.setImage(UIImage(named: "saved"), for: .normal)
            } else {
                // icon save
                saveBtn.setImage(UIImage(named: "save"), for: .normal)
            }
        } else {
            // icon save
            saveBtn.setImage(UIImage(named: "save"), for: .normal)
        }
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
        self.delegate?.reactionDidChange(cell: self)
    }
}
