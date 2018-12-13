//
//  FTContactTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/12/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTContactTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTContactViewModel
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    var contact: FTContact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.round()
        selectionStyle = .none
        layer.cornerRadius = 10
        let shadowPathCusomize = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPathCusomize.cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: FTContactViewModel) {
        contact = data.contact
        if let avatarURL = contact?.user?.avatar {
            avatarImageView.loadImage(fromURL: URL(string: avatarURL), defaultImage: UIImage.userImage())
        } else {
            avatarImageView.image = UIImage.userImage()
        }
        
        usernameLabel.text = contact?.user?.last_name
        if let lastMessage = contact?.room?.last_message {
            lastMessageLabel.text = "\(lastMessage)"
        } else {
            lastMessageLabel.text = nil
        }
    }
}
