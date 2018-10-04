//
//  FTProfileEditDOBCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/3/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

@objc protocol DOBCellDelegate {
    func dobDidChange(cell: FTProfileEditDOBCell)
}

class FTProfileEditDOBCell: UITableViewCell, BECellRenderImpl {

    typealias CellData = FTDOBViewModel
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    weak var delegate: DOBCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateTextField.delegate = self
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var contentData: FTDOBViewModel?
    func renderCell(data: FTDOBViewModel) {
        contentData = data
        titleLabel.text = data.title
        
        let prefill = data.prefil
        dateTextField.text = prefill?.toFTDate()?.dobString()
    }
}

extension FTProfileEditDOBCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        let alert = UIAlertController(style: .actionSheet)
        alert.addDatePicker(mode: .date, date: Date()) { (date) in
            NSLog(date.dateString())
            self.dateTextField.text = date.dobString()
            self.delegate?.dobDidChange(cell: self)
        }
        alert.addAction(title: "Done", style: .default)
        alert.show()
        return false
    }
}
