//
//  FTUserDashBoardProfileCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTUserDashBoardProfileCell: UITableViewCell, BECellRenderImpl {
    
    typealias CellData = FTUserDashBoardViewModel
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var contentData: FTUserProfileResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        avatarImageView.round()
    }
    
    func renderCell(data: FTUserDashBoardViewModel) {
        contentData = data.profile
        if let urlString = contentData?.avatar {
            avatarImageView.loadImage(fromURL: URL(string: urlString), defaultImage: UIImage.userImage())
        } else {
            avatarImageView.image = UIImage.userImage()
        }
        
        usernameLabel.text = contentData?.last_name ?? "Le Cong Toan"
        statusLabel.text = NSLocalizedString("Status now", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
