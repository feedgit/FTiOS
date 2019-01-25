//
//  FTNotificationTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTNotificationTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTNotificationViewModel
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var notifLabel: UILabel!
    @IBOutlet weak var reactImageView: UIImageView!
    
    var contentData: FTNotificationItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        avatarImageView.round()
        reactImageView.round()
    }
    
    func renderCell(data: FTNotificationViewModel) {
        contentData = data.content
        if let urlString = contentData?.from_user?.avatar {
            avatarImageView.loadImage(fromURL: URL(string: urlString), defaultImage: UIImage.userImage())
        } else {
            avatarImageView.image = UIImage.userImage()
        }
        
        // create attributed string
        let username = contentData?.from_user?.username ?? ""
        let usernameAttribute = [ NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18) ]
        var myAttrString = NSMutableAttributedString(string: username, attributes: usernameAttribute)
        
        let contentText = " \(contentData?.type ?? "") your feed"
        let contentAttribute = [ NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 18) ]
        let contentAtributeString = NSAttributedString(string: contentText, attributes: contentAttribute)
        
        myAttrString.append(contentAtributeString)
        
        // set attributed text on a UILabel
        //notifLabel.text = "\(contentData?.from_user?.username ?? "") \(contentData?.type ?? "") your feed"
        
        notifLabel.attributedText = myAttrString
    }
    
}
