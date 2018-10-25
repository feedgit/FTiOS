//
//  FTPhotoCollectionViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/25/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTPhotoCollectionViewCell: UICollectionViewCell, BECellRenderImpl {
    typealias CellData = FTPhotoComposerViewModel
    @IBOutlet var imageViewIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func renderCell(data: FTPhotoComposerViewModel) {
        imageViewIcon.image = data.image
    }

}
