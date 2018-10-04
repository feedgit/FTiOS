//
//  FTProfileEditMultipleLineCellTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/3/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
@objc protocol MutilplLinesCellDelegate {
    func multipleLinesCellDidChange(cell: FTProfileEditMultipleLineCellTableViewCell)
}

class FTProfileEditMultipleLineCellTableViewCell: UITableViewCell, BECellRenderImpl {

    typealias CellData = FTMultipleLinesViewModel
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    weak var delegate: MutilplLinesCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        detailTextView.delegate = self
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var contentData: FTMultipleLinesViewModel?
    func renderCell(data: FTMultipleLinesViewModel) {
        contentData = data
        titleLabel.text = data.title
        
        let prefill = data.prefil
        detailTextView.text = prefill
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        NSLog("\(textField.text ?? "")")
    }
    
}

extension FTProfileEditMultipleLineCellTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        NSLog(textView.text ?? "")
        self.delegate?.multipleLinesCellDidChange(cell: self)
    }
}
