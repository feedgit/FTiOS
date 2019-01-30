//
//  FTReactionTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/30/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit
import SwiftMoment

class FTReactionTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTReactionViewModel
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reactionImageView: UIImageView!
    
    var reaction: FTReactData?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.round()
        selectionStyle = .none
        usernameLabel.font = UIFont.UserNameFont()
        timeLabel.font = UIFont.TimestampFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: FTReactionViewModel) {
        reaction = data.reaction
        avatarImageView.loadImage(fromURL: URL(string: reaction?.user?.avatar ?? ""), defaultImage: UIImage.userImage())
        usernameLabel.text = reaction?.user?.username
        if let timestamp = reaction?.timestamp {
            timeLabel.text = moment(timestamp)?.date.dateString()
        } else {
            timeLabel.text = nil
        }
        
        if let reactType = reaction?.react_type {
            switch reactType {
            case "LIKE", "LOVE":
                reactionImageView.image = UIImage.lovedImage()
            case "LAUGH":
                reactionImageView.image = UIImage.laughImage()
            case "SAD":
                reactionImageView.image = UIImage.sadImage()
            case "WOW":
                reactionImageView.image = UIImage.wowImage()
            case "ANGRY":
                reactionImageView.image = UIImage.angryImage()
            default:
                reactionImageView.image = nil
            }
        } else {
            reactionImageView.image = nil
        }
    }
    
}
