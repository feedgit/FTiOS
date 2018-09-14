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
        self.selectionStyle = .none
        
        // setup lables
        setUpLabels()
        userAvatarImageview.round()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpLabels() {
        let loveAttrString = FTHelpers.attributeString(imageNamed: "love", str: NSLocalizedString("Love", comment: ""))
        loveLabel.attributedText = loveAttrString
        
        let commentAttrString = FTHelpers.attributeString(imageNamed: "comment", str: NSLocalizedString("Comment", comment: ""))
        commentLabel.attributedText = commentAttrString
        
        let shareAttrString = FTHelpers.attributeString(imageNamed: "share", str: NSLocalizedString("Share", comment: ""))
        shareLabel.attributedText = shareAttrString
        
        let saveAttrString = FTHelpers.attributeString(imageNamed: "save", str: NSLocalizedString("Save", comment: ""))
        saveLabel.attributedText = saveAttrString
    }
    
}

extension FTFeedTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.commentTextField.endEditing(true)
        return true
    }
}
