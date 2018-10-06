//
//  FTCommentTextCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/6/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import SwiftMoment

class FTCommentTextCell: UITableViewCell, BECellRenderImpl {
    
    typealias CellData = FTCommentViewModel
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.round()
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
                self.avatarImageView.loadImage(fromURL: url)
            }
        } else {
            self.avatarImageView.image = UIImage(named: "1000x1000")
        }
        
        contentLabel.text = "\(data.comment.user?.last_name ?? "") \(data.comment.comment ?? "")"
        
        if let post_on = data.comment.posted_on {
            dateLabel.text = moment(post_on)?.fromNowFT()
        } else {
            dateLabel.text = nil
        }
    }
    
}
