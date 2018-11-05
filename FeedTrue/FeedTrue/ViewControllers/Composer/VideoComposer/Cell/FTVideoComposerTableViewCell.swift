//
//  FTVideoComposerTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTVideoComposerTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTVideoComposerViewModel
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var contentData: FTVideoComposerViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        titleTextField.placeholder(text: NSLocalizedString("Title", comment: ""))
        descriptionTextField.placeholder(text: NSLocalizedString("Description", comment: ""))
        titleTextField.setPlaceHolderTextColor(.gray)
        descriptionTextField.setPlaceHolderTextColor(.gray)
        deleteImageView.isUserInteractionEnabled = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(removeVideoImage(_:)))
        deleteImageView.addGestureRecognizer(singleTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: FTVideoComposerViewModel) {
        contentData = data
        videoImageView.image = data.image
        titleTextField.text = data.title
        descriptionTextField.text = data.description
    }
    
    @objc func removeVideoImage(_ sender: Any) {
        videoImageView.image = nil
        contentData?.image = nil
    }
    
}
