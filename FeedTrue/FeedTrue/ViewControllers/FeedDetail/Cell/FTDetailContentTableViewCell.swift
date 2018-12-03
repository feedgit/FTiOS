//
//  FTDetailContentTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/26/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTDetailContentTableViewCell: UITableViewCell, BECellRenderImpl {
    
    typealias CellData = FTDetailFeedContentViewModel
    @IBOutlet weak var contentTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentTextView.isEditable = false
        contentTextView.font = UIFont.systemFont(ofSize: 17)
        contentTextView.isScrollEnabled = false
    }
    
    func renderCell(data: FTDetailFeedContentViewModel) {
        contentTextView.text = data.content.htmlToString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
