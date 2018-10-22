//
//  FTUserDashBoardSettingCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTUserDashBoardSettingCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTUserDashBoardSettingViewModel
    
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func renderCell(data: FTUserDashBoardSettingViewModel) {
        settingImageView.image = data.icon
        label.text = data.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
