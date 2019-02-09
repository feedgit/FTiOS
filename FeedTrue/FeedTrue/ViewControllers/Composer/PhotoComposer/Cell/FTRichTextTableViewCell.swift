//
//  FTRichTextTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/31/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit
import RichEditorView

@objc protocol RichTextCellDelegate: NSObjectProtocol {
    @objc func richTextCell(_ editor: RichEditorView, contentDidChange content: String)
}

class FTRichTextTableViewCell: UITableViewCell, BECellRenderImpl {
    weak var delegate: RichTextCellDelegate?
    typealias CellData = FTRichTextViewModel
    @IBOutlet weak var richTextView: RichEditorView!
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        richTextView.inputAccessoryView = toolbar
        richTextView.placeholder = NSLocalizedString("Write something...", comment: "")
        
        //toolbar.delegate = self
        toolbar.editor = richTextView
        
        // We will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar.editor?.html = ""
        }
        
        var options = toolbar.options
        options.append(item)
        toolbar.options = options
        
        richTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: FTRichTextViewModel) {
        richTextView.html = data.content
    }
    
}

extension FTRichTextTableViewCell: RichEditorDelegate {
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        self.delegate?.richTextCell(editor, contentDidChange: content)
    }
}
