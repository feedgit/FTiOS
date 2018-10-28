//
//  FTPhotoCollectionViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/25/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

@objc protocol PhotoCellDelegate {
    func photoCellDidDelete(_ cell: FTPhotoCollectionViewCell)
}

class FTPhotoCollectionViewCell: UICollectionViewCell, BECellRenderImpl {
    typealias CellData = FTPhotoComposerViewModel
    @IBOutlet var imageViewIcon: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    
    var image: UIImage?
    weak var delegate: PhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(deleteCell))
        deleteImageView.isUserInteractionEnabled = true
        deleteImageView.addGestureRecognizer(singleTap)
    }
    
    func renderCell(data: FTPhotoComposerViewModel) {
        image = data.image
        imageViewIcon.image = data.image
    }
    
    @objc func deleteCell() {
        self.delegate?.photoCellDidDelete(self)
    }

}
