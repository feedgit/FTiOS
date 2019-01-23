//
//  FTLocationTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/23/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
