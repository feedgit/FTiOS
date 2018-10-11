//
//  FTFeedVideoCollectionViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTFeedVideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var reactionButton: ReactionButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func commentBtnTouchUpAction(_ sender: Any) {
        
    }
    @IBAction func saveBtnTouchUpAction(_ sender: Any) {
        
    }
    
}
