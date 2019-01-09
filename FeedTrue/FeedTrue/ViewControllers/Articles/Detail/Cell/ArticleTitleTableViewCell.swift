//
//  ArticleTitleTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/9/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class ArticleTitleTableViewCell: UITableViewCell, BECellRenderImpl {

    typealias CellData = ArticleTitleViewModel
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.ArticleTitleFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: ArticleTitleViewModel) {
        titleLabel.text = data.title
    }
    
}
