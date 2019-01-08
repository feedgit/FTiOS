//
//  FTPostInFeedViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/29/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import QuartzCore

@objc protocol PostInFeedDelegate {
    func postInFeedDidSave(viewController: FTPostInFeedViewController)
}

class FTPostInFeedViewController: UIViewController {
    @objc var delegate: PostInFeedDelegate?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var keyboardImageView: UIImageView!
    @IBOutlet weak var hashImageView: UIImageView!
    @IBOutlet weak var stickerImageView: UIImageView!
    let placeHoder = "Write something ..."
    fileprivate var saveBarBtn: UIBarButtonItem!
    var postText = ""
    
    init(postText p: String) {
        postText = p
        super.init(nibName: "FTPostInFeedViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = UIColor.navigationTitleTextColor()
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Post In Feed", comment: "")
        
        saveBarBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save(_:)))
        saveBarBtn.tintColor = .white
        self.navigationItem.rightBarButtonItem = saveBarBtn
        
        setPostText(text: postText)
        textView.layer.cornerRadius = 5
        textView.delegate = self
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func save(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.postInFeedDidSave(viewController: self)
    }
    
    func getPostText() -> String {
        if textView.text != placeHoder {
            return textView.text
        }
        
        return ""
    }
    
    func setPostText(text: String) {
        if text == "" {
            textView.text = placeHoder
            textView.textColor = UIColor.darkGray
        } else if text != placeHoder {
            textView.text = text
            textView.textColor = .black
        }
    }

}

extension FTPostInFeedViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHoder {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeHoder
            textView.textColor = UIColor.darkGray
        }
        textView.resignFirstResponder()
    }
}
