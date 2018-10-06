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
        self.selectionStyle = .none
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
        let lastname = data.comment.user?.last_name ?? ""
        let lastnameAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.blue ]
        let lastnameAttrString = NSAttributedString(string: lastname, attributes: lastnameAttribute)
        
        let content = data.comment.comment?.htmlToString ?? ""
        let contentAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.black ]
        let contentAttrString = NSAttributedString(string: content, attributes: contentAttribute)
        
        let attString = NSMutableAttributedString(attributedString: lastnameAttrString)
        attString.append(NSAttributedString(string: " "))
        attString.append(contentAttrString)

        //contentLabel.text = "\(lastname) \(data.comment.comment?.htmlToString ?? "")"
        contentLabel.attributedText = attString
        if let post_on = data.comment.posted_on {
            dateLabel.text = moment(post_on)?.fromNowFT()
        } else {
            dateLabel.text = nil
        }
    }
    
}
