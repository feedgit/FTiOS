//
//  FTMenuItemTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/24/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTMenuItemTableViewCell: UITableViewCell, BECellRenderImpl {

    typealias CellData = FTUserDashBoardMenuViewModel
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: FTUserDashBoardMenuViewModel) {
        imageViewIcon.image = data.icon
        titleLabel.text = data.title
    }
    
}
