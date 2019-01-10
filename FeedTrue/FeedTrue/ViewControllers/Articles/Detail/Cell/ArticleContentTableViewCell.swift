//
//  ArticleContentTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/10/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class ArticleContentTableViewCell: UITableViewCell, BECellRenderImpl {
    
    typealias CellData = ArticleContentViewModel
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        contentTextView.font = UIFont.contentFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: ArticleContentViewModel) {
        contentTextView.text = data.content.htmlToString
    }
    
}
