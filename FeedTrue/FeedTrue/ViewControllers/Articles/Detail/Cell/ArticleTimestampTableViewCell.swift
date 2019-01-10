//
//  ArticleTimestampTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/10/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class ArticleTimestampTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = TimestampViewModel
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        timeLabel.font = UIFont.TimestampFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: TimestampViewModel) {
        timeLabel.text = data.timestamp
    }
}
