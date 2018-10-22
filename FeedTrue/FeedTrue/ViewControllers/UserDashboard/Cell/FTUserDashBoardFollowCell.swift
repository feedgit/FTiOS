//
//  FTUserDashBoardFollowCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTUserDashBoardFollowCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTUserDashBoardViewModel
    
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var loverLabel: UILabel!
    var contentData: FTUserProfileResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    func renderCell(data: FTUserDashBoardViewModel) {
        contentData = data.profile
        if let lovedCount = contentData?.loved, lovedCount > 0 {
            loverLabel.text = "\(lovedCount)"
        } else {
            loverLabel.text = "0"
        }
        
        if let followCount = contentData?.follows_viewer, followCount > 0 {
            followLabel.text = "\(followCount)"
        } else {
            followLabel.text = "0"
        }
        
        if let followerCount = contentData?.followed_by_viewer, followerCount > 0 {
            followerLabel.text = "\(followerCount)"
        } else {
            followerLabel.text = "0"
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
