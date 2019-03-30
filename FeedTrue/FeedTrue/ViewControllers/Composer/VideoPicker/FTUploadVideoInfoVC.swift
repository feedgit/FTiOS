//
//  FTUploadVideoInfoVC.swift
//  FeedTrue
//
//  Created by Quoc Le on 3/30/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTUploadVideoInfoVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextview: UITextView!
    var placeholderLabel : UILabel!
    var infoDescription: String?
    var infoTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        descriptionTextview.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter your video description, hashtag, location, ..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (descriptionTextview.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        descriptionTextview.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextview.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !descriptionTextview.text.isEmpty
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        NSLog("\(#function) text: \(String(describing: textView.text))")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        NSLog("\(#function) text: \(textField.text ?? "")")
    }
    
    func isValidInfo() -> Bool {
        guard let des = descriptionTextview.text, !des.isEmpty else { return false }
        
        guard let tl = titleTextField.text, !tl.isEmpty else { return false }
        
        return true
    }
}
