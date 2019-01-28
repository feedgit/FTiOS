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
    func photoCellDidTapEdit(_ cell: FTPhotoCollectionViewCell)
}

class FTPhotoCollectionViewCell: UICollectionViewCell, BECellRenderImpl {
    typealias CellData = FTPhotoComposerViewModel
    @IBOutlet var imageViewIcon: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    var image: UIImage?
    weak var delegate: PhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(deleteCell))
        deleteImageView.isUserInteractionEnabled = true
        deleteImageView.addGestureRecognizer(singleTap)
        
        editButton.setTitleColor(.black, for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        editButton.isUserInteractionEnabled = true
        editButton.addTarget(self, action: #selector(editCell), for: .touchUpInside)
    }
    
    func renderCell(data: FTPhotoComposerViewModel) {
        image = data.image
        imageViewIcon.image = data.image
    }
    
    @objc func deleteCell() {
        self.delegate?.photoCellDidDelete(self)
    }

    @objc func editCell() {
        self.delegate?.photoCellDidTapEdit(self)
    }
}
