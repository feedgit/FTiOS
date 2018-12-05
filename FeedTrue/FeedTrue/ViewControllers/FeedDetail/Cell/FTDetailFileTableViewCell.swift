//
//  FTDetailFileTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/3/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTDetailFileTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTDetailFileViewModel
    @IBOutlet weak var savedBtn: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var reactionCountLabel: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var reactionButton: ReactionButton!
    var ftReactionType: FTReactionTypes = .love
    var feed: FTFeedInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reactionButton.reactionSelector = ReactionSelector()
        reactionButton.config           = ReactionButtonConfig() {
            $0.iconMarging      = 10
            $0.spacing          = 0
            $0.font             = UIFont(name: "HelveticaNeue", size: 0)
            $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
            $0.alignment        = .centerLeft
        }
        reactionButton.backgroundColor = .clear
        reactionButton.reactionSelector?.feedbackDelegate = self
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(_:)))
        self.addGestureRecognizer(singleTap)
    }
    
    func renderCell(data: FTDetailFileViewModel) {
        feed = data.feed
        // config react icon
        if let reactCount = feed.reactions?.count {
            self.reactionCountLabel.text = reactCount > 0 ? "\(reactCount)" : nil
        } else {
            self.reactionCountLabel.text = nil
        }
        
        if let reactType = feed.request_reacted {
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
        if let saved = feed.saved {
            if saved {
                // icon saved
                savedBtn.setImage(UIImage(named: "saved"), for: .normal)
            } else {
                // icon save
                savedBtn.setImage(UIImage(named: "save"), for: .normal)
            }
        } else {
            // icon save
            savedBtn.setImage(UIImage(named: "save"), for: .normal)
        }
        
        if let count = data.feed.comment?.count {
            self.commentCountLabel.text = count > 0 ? "\(count)" : nil
        } else {
            self.commentCountLabel.text = nil
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func reactionButtonTouchUpAction(_ sender: Any) {
        reactionButton.reaction   = Reaction.facebook.like
        ftReactionType = .love
        if reactionButton.isSelected == false {
            //self.delegate?.feedCellDidRemoveReaction(cell: self)
        } else {
            //self.delegate?.feedCellDidChangeReactionType(cell: self)
        }
    }
    
    @IBAction func savedTouchUpAction(_ sender: Any) {
        if let saved = feed.saved {
            if saved {
                //self.delegate?.feedCellDidUnSave(cell: self)
                self.savedBtn.setImage(UIImage(named: "save"), for: .normal)
                self.feed.saved = false
                return
            }
        }
        self.savedBtn.setImage(UIImage(named: "saved"), for: .normal)
        self.feed.saved = true
        //self.delegate?.feedCellDidSave(cell: self)
    }
    
    @IBAction func commentTouchUpAction(_ sender: Any) {
        //self.delegate?.feedCellDidTouchUpComment(cell: self)
        //showDetail()
    }

    @objc func singleTapHandler(_ sender: Any) {
        print(#function)
    }
    
}

extension FTDetailFileTableViewCell: ReactionFeedbackDelegate {
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
        //self.delegate?.feedCellDidChangeReactionType(cell: self)
    }
}
