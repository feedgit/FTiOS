//
//  FTCategoryTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 2/20/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTCategoryTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTFeedCategory
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var contentData: FTFeedCategory!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        titleLabel.font = UIFont.UserNameFont()
        descriptionLabel.font = UIFont.descriptionFont()
        
        titleLabel.textColor = .black
        descriptionLabel.textColor = .gray
        
        iconImageView.clipsToBounds = true
        
        iconImageView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: FTFeedCategory) {
        contentData = data
        iconImageView.image = contentData.icon
        iconImageView.backgroundColor = contentData.background
        titleLabel.text = contentData.label
        descriptionLabel.text = contentData.description
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        imageView?.backgroundColor = .clear
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    
}
