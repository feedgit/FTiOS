//
//  FTPrivacyPickerTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/29/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTPrivacyPickerTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTPrivacyViewModel
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func renderCell(data: FTPrivacyViewModel) {
        imageViewIcon.image = UIImage(named: data.privacy.imageName)
        titleLabel.text = data.privacy?.title
        detailLabel.text = data.privacy?.detail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
