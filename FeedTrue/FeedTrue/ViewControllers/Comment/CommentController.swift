//
//  CommentController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class CommentController: UITableViewController {
    var feed: FTFeedInfo!
    var coreService: FTCoreService!
    var datasource: [FTCommentViewModel] = []
    
    init(c: FTCoreService, f: FTFeedInfo, comments: [FTCommentViewModel]) {
        feed = f
        coreService = c
        datasource = comments
        super.init(nibName: "CommentController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FTCommentViewModel.register(tableView: self.tableView)
        self.tableView.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        if let text = self.messageInputView.textView.text {
            let messageText =  text.trimmingCharacters(in: .whitespacesAndNewlines)
            // do something with message view
            self.messageInputView.textView.text = ""
            self.messageInputView.textViewDidChange(messageInputView.textView)
            
            guard let ct_name = feed.ct_name else { return }
            guard let ct_id = feed.id else { return }
            guard let token = coreService.registrationService?.authenticationProfile?.accessToken else { return }
            coreService.webService?.sendComment(token: token, ct_name: ct_name, ct_id: ct_id, comment: messageText, parentID: nil, completion: { [weak self] (success, comment) in
                if success {
                    guard let c = comment else { return }
                    let cm = FTCommentViewModel(comment: c, type: .text)
                    self?.datasource.append(cm)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                } else {
                    // TODO: remove error comment
                }
            })
        }
        // hide keyboard after send (just to show how accessory view behave when keyboard hides)
        self.messageInputView.textView.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = datasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        
        if let commentCell = cell as? BECellRender {
            commentCell.renderCell(data: content)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = datasource[indexPath.row]
        return content.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            NSLog("delete at index: \(indexPath.row)")
            let content = self.datasource[indexPath.row]
            guard let ct_id = content.comment.id else { return }
            guard let token = self.coreService.registrationService?.authenticationProfile?.accessToken else { return }
            self.coreService.webService?.deleteComment(token: token, ct_id: ct_id, completion: { [weak self] (success, msg) in
                if success {
                    self?.datasource.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            })
        }
        return [deleteAction]
    }
    
    
}
