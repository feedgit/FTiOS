//
//  CommentController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class CommentController: UITableViewController {
    enum CommentDataType {
        case comment
        case reply
        case edit
    }
    
    var type: CommentDataType = .comment
    //var feed: FTFeedInfo!
    var contentID: Int?
    var ctName: String?
    var coreService: FTCoreService!
    var datasource: [[FTCommentViewModel]] = []
    var replyComment: FTCommentViewModel?
    var editComment: FTCommentViewModel?
    var nextURLString: String?
    
    init(c: FTCoreService, contentID id: Int?, ctName ct_name: String?) {
        coreService = c
        contentID = id
        ctName = ct_name
        super.init(nibName: "CommentController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FTCommentViewModel.register(tableView: self.tableView)
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.loadComment()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(clearTouchUpAction(_:)))
        messageInputView.clearBtn.isUserInteractionEnabled = true
        messageInputView.clearBtn.addGestureRecognizer(singleTap)
    }
    
    func loadComment() {
        guard let feedID = contentID else { return }
        coreService.webService?.getComments(ct_id: feedID, completion: { [weak self] (success, response) in
            if success {
                // TODO: init datasource
                guard let results = response?.results else { return }
                self?.nextURLString = response?.next
                self?.datasource.removeAll()
                for item in results {
                    var comments:[ FTCommentViewModel] = []
                    comments.append(FTCommentViewModel(comment: item, type: .text))
                    if let replies = item.replies {
                        for rp in replies {
                            comments.append([FTCommentViewModel(comment: rp, type: .text)])
                        }
                    }
                    
                    self?.datasource.append(comments)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.tableView.addBotomActivityView {
                        self?.loadMore()
                    }
                }
            } else {
                // TODO:
            }
        })
    }
    
    func loadMore() {
        guard let nextURL = self.nextURLString, !nextURL.isEmpty else {
            self.tableView.removeBottomActivityView()
            return
        }
        guard let token = coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        
        coreService.webService?.getMoreComments(nextString: nextURL, completion: { [weak self] (success, response) in
            if success {
                NSLog("Load more comment successful \(response?.next ?? "")")
                self?.nextURLString = response?.next
                DispatchQueue.main.async {
                    if let results = response?.results {
                        if results.count > 0 {
                            self?.tableView.endBottomActivity()
                            for item in results {
                                var comments:[ FTCommentViewModel] = []
                                comments.append(FTCommentViewModel(comment: item, type: .text))
                                if let replies = item.replies {
                                    for rp in replies {
                                        comments.append([FTCommentViewModel(comment: rp, type: .text)])
                                    }
                                }
                                
                                self?.datasource.append(comments)
                            }
                            self?.tableView.reloadData()
                        } else {
                            self?.tableView.removeBottomActivityView()
                        }
                    }
                    
                    
                }
            } else {
                DispatchQueue.main.async {
                    self?.tableView.removeBottomActivityView()
                }
            }
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var messageInputView: ChatAccessoryView! = {
        let footerView = ChatAccessoryView.getView(target: self, actionName: "SEND", action: #selector(sendMessage))
        return footerView
    }()
    
    @objc func clearTouchUpAction(_ sender: UIImageView) {
        messageInputView.clearBtn.isHidden = true
        self.type = .comment
        self.messageInputView.textView.text = ""
        self.messageInputView.actionButton.setTitle("SEND", for: .normal)
        self.replyComment = nil
        
    }
    
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
            self.messageInputView.clearBtn.isHidden = true
            guard let ct_name = ctName else { return }
            guard let ct_id = contentID else { return }
            let parentID = self.replyComment?.comment.id
            if self.type == .edit {
                self.messageInputView.clearBtn.isHidden = true
                guard let comment_id = self.editComment?.comment.id else { return }
                coreService.webService?.editComment(ct_id: comment_id, comment: messageText, parentID: nil, completion: { (success, response) in
                    if success {
                        // TODO: update edited comment
                        guard let editComment = response?.comment else { return }
                        for i in 0..<self.datasource.count {
                            for j in 0..<self.datasource[i].count {
                                guard let item_id = self.datasource[i][j].comment.id else { continue }
                                if item_id == comment_id {
                                    self.datasource[i][j].comment.comment = editComment
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                    return
                                }
                            }
                        }
                    } else {
                        
                    }
                })
            } else {
                coreService.webService?.sendComment(ct_name: ct_name, ct_id: ct_id, comment: messageText, parentID: parentID, completion: { [weak self] (success, comment) in
                    if success {
                        guard let c = comment else { return }
                        let cm = FTCommentViewModel(comment: c, type: .text)
                        self?.addComment(c: cm, parentID: parentID)
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                            self?.type = .comment
                            self?.messageInputView.actionButton.setTitle("SEND", for: .normal)
                            self?.replyComment = nil
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            self?.type = .comment
                            self?.messageInputView.actionButton.setTitle("SEND", for: .normal)
                            self?.replyComment = nil
                        }
                    }
                })
            }
        }
        // hide keyboard after send (just to show how accessory view behave when keyboard hides)
        self.messageInputView.textView.resignFirstResponder()
    }
    
    
    func addComment(c: FTCommentViewModel, parentID: Int?) {
        switch type {
        case .comment:
            datasource.append([c])
        case .reply:
            for i in 0..<datasource.count {
                guard let item_id = datasource[i].first?.comment.id else { continue }
                guard let parent_id = parentID else { continue }
                if item_id == parent_id {
                    datasource[i].append(c)
                }
            }
        case .edit:
            break
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = datasource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier()) as! FTCommentTextCell
        cell.delegate = self
        
        cell.renderCell(data: content)
        
        content.reply = { (comment) in
            self.messageInputView.actionButton.setTitle("REPLY", for: .normal)
            self.type = .reply
            self.replyComment = comment
        }
        
        if indexPath.row == 0 {
            cell.paddingLeftLayoutConstraint.constant = 8
            cell.replyBtn.isHidden = false
        } else {
            cell.paddingLeftLayoutConstraint.constant = 32
            cell.replyBtn.isHidden = true
        }
        
        content.more = { (contentCell) in
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                NSLog("delete at index: \(indexPath.row)")
                guard let content = contentCell else { return }
                guard let ct_id = content.comment.id else { return }
                self.coreService.webService?.deleteComment(ct_id: ct_id, completion: { [weak self] (success, msg) in
                    if success {
                        self?.datasource.remove(at: indexPath.row)
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                })
            })
            
            let editAction = UIAlertAction(title: NSLocalizedString("Edit", comment: ""), style: .default, handler: { (action) in
                self.messageInputView.clearBtn.isHidden = false
                self.messageInputView.textView.text = contentCell?.comment.comment
                self.messageInputView.placeholder.isHidden = true
                self.type = .edit
                self.editComment = contentCell
            })
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: { (action) in
                
            })
            
            FTAlertViewManager.defaultManager.showActions(nil, message: nil, actions: [deleteAction, editAction, cancelAction], view: self)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = datasource[indexPath.section][indexPath.row]
        return content.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let content = datasource[indexPath.section][indexPath.row]
        if content.comment.editable == false {
            return false
        }
        
        return false
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            NSLog("delete at index: \(indexPath.row)")
            let content = self.datasource[indexPath.section][indexPath.row]
            guard let ct_id = content.comment.id else { return }
            self.coreService.webService?.deleteComment(ct_id: ct_id, completion: { [weak self] (success, msg) in
                if success {
                    self?.datasource.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            })
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // TODO: show edit view
        }
        return [deleteAction, editAction]
    }
    
    
}

extension CommentController: FTCommentTextCellDelegate {
    func commentCellDidRemoveReaction(cell: FTCommentTextCell) {
        guard let comment = cell.contentData?.comment else { return }
        guard let ct_id = comment.id else { return }
        guard let ct_name = comment.ct_name else { return }
        coreService.webService?.removeReact(ct_name: ct_name, ct_id: ct_id, completion: { (success, msg) in
            if success {
                NSLog("Remove react successful")
            } else {
                NSLog("Remove react failed")
                DispatchQueue.main.async {
                    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
    
    func commentCellDidChangeReactionType(cell: FTCommentTextCell) {
        guard let comment = cell.contentData?.comment else { return }
        guard let ct_id = comment.id else { return }
        guard let ct_name = comment.ct_name else { return }
        let react_type = cell.ftReactionType.rawValue
        coreService.webService?.react(ct_name: ct_name, ct_id: ct_id, react_type: react_type, completion: { (success, type) in
            if success {
                NSLog("did react successful \(type ?? "")")
            } else {
                NSLog("did react failed \(react_type)")
                DispatchQueue.main.async {
                    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
}
