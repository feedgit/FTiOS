//
//  UsernameLabelTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/10/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class UsernameLabelTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = UsernameLabelViewModel
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        usernameLabel.font = UIFont.UserNameBlueFont()
        usernameLabel.textColor = UIColor.usernameBlueColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: UsernameLabelViewModel) {
        usernameLabel.text = data.user.username
    }
    
}
