//
//  ArticleThumbnailTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/9/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class ArticleThumbnailTableViewCell: UITableViewCell, BECellRenderImpl {

    typealias CellData = ArticelThumbnailViewModel
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: ArticelThumbnailViewModel) {
        thumbnailImageView.loadImage(fromURL: URL(string: data.thumbnailURL), defaultImage: UIImage.noImage())
    }
    
}
