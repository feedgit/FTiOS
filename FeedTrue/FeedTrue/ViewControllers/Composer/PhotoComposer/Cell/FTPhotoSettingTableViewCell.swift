//
//  FTPhotoSettingTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/26/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTPhotoSettingTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTPhotoSettingViewModel
    
    @IBOutlet weak var icImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    func renderCell(data: FTPhotoSettingViewModel) {
        icImageView.image = (data.icon != nil) ? UIImage(named: data.icon!) : nil
        label.text = data.title
        markImageView.image = (data.markIcon != nil) ? UIImage(named: data.markIcon!) : nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
