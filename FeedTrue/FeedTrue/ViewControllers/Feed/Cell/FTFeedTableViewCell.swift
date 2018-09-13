//
//  FTFeedTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/13/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarImageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var feedContentTextview: UITextView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var loveLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentTextField.returnKeyType = .done
        commentTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension FTFeedTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.commentTextField.endEditing(true)
        return true
    }
}
