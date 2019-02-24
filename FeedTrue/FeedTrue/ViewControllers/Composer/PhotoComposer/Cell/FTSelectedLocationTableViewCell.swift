//
//  FTSelectedLocationTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 2/24/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

@objc protocol SelectedLocationCellDelegate {
    func selectedLocationRemoveAction()
}

class i: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTSelectedLocationVM
    weak var delegate: SelectedLocationCellDelegate?
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    @IBOutlet weak var deleteImageView: UIImageView!
    
    var location: FTLocationProperties!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(deleteAction))
        deleteImageView.isUserInteractionEnabled = true
        deleteImageView.addGestureRecognizer(singleTap)
        deleteImageView.image = UIImage.deleteLocationImage()
        
        locationNameLabel.font = UIFont.UserNameFont()
        locationDescriptionLabel.font = UIFont.descriptionFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: FTSelectedLocationVM) {
        location = data.locationProperties
        thumbnailImageView.loadImage(fromURL: URL(string: location.locationThumbnail), defaultImage: UIImage.noImage())
        locationNameLabel.text = location.locationName
        locationDescriptionLabel.text = location.locationAddress
    }
    
    @objc func deleteAction() {
        self.delegate?.selectedLocationRemoveAction()
    }
    
}
