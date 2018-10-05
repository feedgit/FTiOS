//
//  CommentController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class CommentController: UITableViewController {
    lazy var messageInputView: ChatAccessoryView! = {
        let footerView = ChatAccessoryView.getView(target: self, actionName: "SEND", action: #selector(sendMessage))
        return footerView
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return self.messageInputView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    @objc func sendMessage() {
        //get message from textview
        if let text = self.messageInputView.textView.text {
            let messageText =  text.trimmingCharacters(in: .whitespacesAndNewlines)
            // do something with message view
            self.messageInputView.textView.text = ""
            self.messageInputView.textViewDidChange(messageInputView.textView)
        }
        // hide keyboard after send (just to show how accessory view behave when keyboard hides)
        self.messageInputView.textView.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "Hello world"
        // Configure the cell...
        
        return cell
    }
    
}
