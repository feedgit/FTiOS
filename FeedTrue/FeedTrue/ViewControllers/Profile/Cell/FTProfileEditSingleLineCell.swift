//
//  FTProfileEditSingleLineCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/3/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTProfileEditSingleLineCell: UITableViewCell, BECellRenderImpl, UITextFieldDelegate {
    typealias CellData = FTSingleLineViewModel
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var contentData: FTSingleLineViewModel?
    func renderCell(data: FTSingleLineViewModel) {
        contentData = data
        titleLabel.text = data.title
        
        let prefill = data.prefil
        detailTextField.text = prefill
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        NSLog("\(textField.text ?? "")")
    }
    
}
