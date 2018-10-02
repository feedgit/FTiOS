//
//  EditTextTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

enum EditProfileCellType: Int {
    case username = 0
    case firstname = 1
    case lastname = 2
    case gender = 3
    case intro = 4
    case about = 5
}

@objc protocol EditTextDelegate {
    func usernameDidChange(username: String?)
    func firstnameDidChange(firstname: String?)
    func lastnameDidChange(lastname: String?)
    func genderDidChange(gender: String?)
    func introDidChange(intro: String?)
    func aboutDidChange(about: String?)
    func textDidChange()
}

class EditTextTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textFiled: UITextField!
    var cellType: EditProfileCellType!
    weak var delegate: EditTextDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textFiled.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.delegate?.textDidChange()
        if let type = cellType {
            switch type {
            case .username:
                self.delegate?.usernameDidChange(username: textField.text)
            case .firstname:
                self.delegate?.firstnameDidChange(firstname: textField.text)
            case .lastname:
                self.delegate?.lastnameDidChange(lastname: textField.text)
            case .gender: break
//                self.delegate?.genderDidChange(gender: textField.text)
            case .intro:
                self.delegate?.introDidChange(intro: textField.text)
            case .about:
                self.delegate?.aboutDidChange(about: textField.text)
            }
        }
    }
    
}
