//
//  FTFeedDetailViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/26/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import STPopup

class FTFeedDetailViewController: UIViewController {

    private var datas: [String] = ["Liked by 123", "Comments 456", "ReFeed 123"]

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var reactTableView: UITableView!
    var feedInfo: FTFeedInfo!
    var coreService: FTCoreService!
    var dataSource = [[BECellDataSource]]()
    var photos: [Photo]?
    var skPhotos: [SKPhoto]?
    var reactionDataSource = [FTBottomReactionViewModel]()
    
    lazy var navTitleView: UIView = {
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        label.text = getUserName()
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = .center
        label.textColor = .white
        
        // Create the image view
        let avatarImageView = UIImageView()
        if let urlString = feedInfo.user?.avatar {
            if let url = URL(string: urlString) {
                avatarImageView.loadImage(fromURL: url, defaultImage: UIImage.userImage())
            } else {
                avatarImageView.image = UIImage.userImage()
            }
        } else {
            avatarImageView.image = UIImage.userImage()
        }
        // To maintain the image's aspect ratio:
        let imageAspect = avatarImageView.image!.size.width / avatarImageView.image!.size.height
        // Setting the image frame so that it's immediately before the text:
        avatarImageView.frame = CGRect(x: label.frame.origin.x - 40, y: label.frame.origin.y - 8, width: 32, height: 32)
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.round()
        
        // Add both the label and image view to the navView
        navView.addSubview(label)
        navView.addSubview(avatarImageView)
        return navView
    }()
    
    lazy var swipeMenuView: SwipeMenuView = {
        let swipeMenuView = SwipeMenuView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        swipeMenuView.delegate                        = self
        swipeMenuView.dataSource                      = self
        var options: SwipeMenuViewOptions             = .init()
        options.tabView.style                         = .segmented
        options.tabView.additionView.backgroundColor  = .white
        options.tabView.itemView.textColor            = .black
        options.tabView.itemView.font = UIFont.swipeMenuFont(ofSize: 17)
        return swipeMenuView
    }()
    
    init(feedInfo info: FTFeedInfo, coreService service: FTCoreService) {
        self.feedInfo = info
        self.coreService = service
        super.init(nibName: "FTFeedDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        
        navigationItem.titleView = navTitleView
        
        let rightBarBtn = UIBarButtonItem(image: UIImage(named: "more_btn"), style: .plain, target: self, action: #selector(more(_:)))
        rightBarBtn.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarBtn
        
        // table view
        dataSource = []
        FTDetailFeedContentViewModel.register(tableView: tableView)
        FTDetailPhotosViewModel.register(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        generateDataSource()
        
        reactionDataSource = []
        FTBottomReactionViewModel.register(tableView: reactTableView)
        reactTableView.delegate = self
        reactTableView.dataSource = self
        reactTableView.tableFooterView = UIView()
        reactTableView.separatorInset = .zero
        reactTableView.layer.cornerRadius = 8
        reactTableView.clipsToBounds = true
        reactTableView.separatorStyle = .none
        generateReactionDatasource()
    }
    
    fileprivate func generateDataSource() {
        let contentVM = FTDetailFeedContentViewModel(content: feedInfo.text ?? "")
        let photoVM = FTDetailPhotosViewModel(photos: photos ?? [])
        dataSource.append([contentVM, photoVM])
        let commentVM = FTDetailFeedContentViewModel(content: "Test")
        dataSource.append([commentVM])
    }
    
    fileprivate func generateReactionDatasource() {
        let reactionVM = FTBottomReactionViewModel(reactionType: .love)
        reactionVM.feedInfo = feedInfo
        reactionDataSource.append(reactionVM)
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func getUserName() -> String? {
        guard let username = feedInfo.user?.last_name else { return nil }
        return username
    }
    
    @objc func more(_ sender: Any) {
        
        /*
         Case 1: If feed.editable = false (Case feed owner is not request user), user can be get into these actions:
         Go to feed: Change screen into FEED DETAIL
         Share: Open Share Feed Modal
         See less content: Temporarily open modal: "You wont see this content anymore" and remove this feed out of feed list.
         Report inapproriate: Temporarily open modal: "Successfully reported" and remove this feed out of feed list.
         */
        let gotoFeedAction = UIAlertAction(title: NSLocalizedString("Go to feed", comment: ""), style: .default) { (action) in
            //self.delegate?.feeddCellGotoFeed(cell: self)
        }
        
        let shareAction = UIAlertAction(title: NSLocalizedString("Share", comment: ""), style: .default) { (action) in
            //self.delegate?.feeddCellShare(cell: self)
        }
        
        let seeLessContentAction = UIAlertAction(title: NSLocalizedString("See less content", comment: ""), style: .default) { (action) in
            //self.delegate?.feeddCellSeeLessContent(cell: self)
        }
        
        let reportInapproriate = UIAlertAction(title: NSLocalizedString("Report inapproriate", comment: ""), style: .default) { (action) in
            //self.delegate?.feeddCellReportInapproriate(cell: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // user cancel
        }
        
        var actions:[UIAlertAction] = []
        if feedInfo.editable == true {
            /*
             Edit: Open modal Edit
             Permanently Delete: (with text-color Red): DELETE /f/${feedID}/delete/ and remove this feed out of feed list
             */
            let editAction = UIAlertAction(title: NSLocalizedString("Edit", comment: ""), style: .default) { (action) in
                //self.delegate?.feeddCellEdit(cell: self)
            }
            
            let permanentlyDeleteAction = UIAlertAction(title: NSLocalizedString("Permanently Delete", comment: ""), style: .destructive) { (action) in
                //self.delegate?.feeddCellPermanentlyDelete(cell: self)
                
            }
            actions = [gotoFeedAction, shareAction, seeLessContentAction, reportInapproriate, editAction, permanentlyDeleteAction, cancelAction]
        } else {
            actions = [gotoFeedAction, shareAction, seeLessContentAction, reportInapproriate, cancelAction]
        }
        FTAlertViewManager.defaultManager.showActions(nil, message: nil, actions: actions, view: self)
    }

}

extension FTFeedDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == reactTableView {
            return 1
        }
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == reactTableView {
            return reactionDataSource.count
        }
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == reactTableView {
            let content = reactionDataSource[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
            
            if let renderCell = cell as? BECellRender {
                renderCell.renderCell(data: content)
            }
            
            if let reactionCell = cell as? FTBottomReactionTableViewCell {
                reactionCell.delegate = self
            }
            return cell
        }
        
        let content = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        
        if let renderCell = cell as? BECellRender {
            renderCell.renderCell(data: content)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == reactTableView {
            let content = reactionDataSource[indexPath.row]
            return content.cellHeight()
        }
        let content = dataSource[indexPath.section][indexPath.row]
        return content.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == reactTableView {
            return nil
        }
        if section == 0 { return nil }
        return swipeMenuView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == reactTableView {
            return 0
        }
        if section == 0 { return 0 }
        return swipeMenuView.bounds.height
    }
    
}

extension FTFeedDetailViewController: SwipeMenuViewDelegate, SwipeMenuViewDataSource {
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        return UIViewController()
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return datas[index]
    }
    
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return datas.count
    }
}

extension FTFeedDetailViewController: BottomReactionCellDelegate {
    func reactionDidRemove(cell: FTBottomReactionTableViewCell) {
        // TODO: remove reaction
        guard let ct_id = feedInfo.id else { return }
        guard let ct_name = feedInfo.ct_name else { return }
        coreService.webService?.removeReact(ct_name: ct_name, ct_id: ct_id, completion: { (success, msg) in
            if success {
                NSLog("Remove react successful")
            } else {
                NSLog("Remove react failed")
                DispatchQueue.main.async {
                    guard let indexPath = self.reactTableView.indexPath(for: cell) else { return }
                    self.reactTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
    
    func reactionDidChange(cell: FTBottomReactionTableViewCell) {
        // TODO: reaction change
        guard let ct_id = feedInfo.id else { return }
        guard let ct_name = feedInfo.ct_name else { return }
        guard let react_type = cell.contentData?.ftReactionType.rawValue else { return }
        coreService.webService?.react(ct_name: ct_name, ct_id: ct_id, react_type: react_type, completion: { (success, type) in
            if success {
                NSLog("did react successful \(type ?? "")")
            } else {
                NSLog("did react failed \(react_type)")
                DispatchQueue.main.async {
                    guard let indexPath = self.reactTableView.indexPath(for: cell) else { return }
                    self.reactTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
    
    func commentDidTouchUpAction(cell: FTBottomReactionTableViewCell) {
        // TODO: open comment view controller
        var comments: [FTCommentViewModel] = []
        if let items = feedInfo.comment?.comments {
            for item in items {
                let cmv = FTCommentViewModel(comment: item, type: .text)
                comments.append(cmv)
            }
        }
        
        let commentVC = CommentController(c: coreService, contentID: feedInfo.id, ctName: feedInfo.ct_name)
        commentVC.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.75)
        let popupController = STPopupController(rootViewController: commentVC)
        popupController.style = .bottomSheet
        popupController.present(in: self)
    }
    
    func reationDidUnSave(cell: FTBottomReactionTableViewCell) {
        guard let ct_id = feedInfo.id else { return }
        guard let ct_name = feedInfo.ct_name else { return }
        coreService.webService?.removeSaveFeed(ct_name: ct_name, ct_id: ct_id, completion: { (success, message) in
            if success {
                NSLog("Remove saved Feed successful ct_name: \(ct_name) ct_id: \(ct_id)")
            } else {
                NSLog("Remove saved Feed failed ct_name: \(ct_name) ct_id: \(ct_id)")
                DispatchQueue.main.async {
                    guard let indexPath = self.reactTableView.indexPath(for: cell) else { return }
                    cell.contentData?.feedInfo?.saved = true
                    self.reactTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
    
    func reactionDidSave(cell: FTBottomReactionTableViewCell) {
        guard let ct_id = feedInfo.id else { return }
        guard let ct_name = feedInfo.ct_name else { return }
        coreService.webService?.saveFeed(ct_name: ct_name, ct_id: ct_id, completion: { (success, message) in
            if success {
                NSLog("Save Feed successful ct_name: \(ct_name) ct_id: \(ct_id)")
            } else {
                NSLog("Save Feed failed ct_name: \(ct_name) ct_id: \(ct_id)")
                DispatchQueue.main.async {
                    guard let indexPath = self.reactTableView.indexPath(for: cell) else { return }
                    cell.contentData?.feedInfo?.saved = false
                    self.reactTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
}
