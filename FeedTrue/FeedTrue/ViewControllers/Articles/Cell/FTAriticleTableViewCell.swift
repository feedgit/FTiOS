//
//  FTAriticleTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/19/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTAriticleTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userImageView: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var loveLabel: UILabel!
    @IBOutlet weak var reactionButton: ReactionButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    
    @IBAction func replyTouchUpAction(_ sender: Any) {
        
    }
    
    @IBAction func saveTouchUpAction(_ sender: Any) {
        
    }
    
    @IBAction func reactionButtonTouchUpAction(_ sender: Any) {
        
    }
}
