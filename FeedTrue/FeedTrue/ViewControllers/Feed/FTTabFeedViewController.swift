//
//  FTTabFeedViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import MBProgressHUD
import SwiftMoment
import STPopup

class FTTabFeedViewController: FTTabViewController {
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [FTFeedViewModel]()
    var nextURLString: String?
    var refreshControl: UIRefreshControl?
    private var progressHub: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = []
        FTFeedViewModel.register(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        
        self.setUpSegmentControl()
        self.setUpRefreshControl()
        NotificationCenter.default.addObserver(self, selector: #selector(feedTabTouchAction), name: .FeedTabTouchAction, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadFeed() {
        _ = self.view
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        self.rootViewController.coreService.webService?.getFeed(page: 1, per_page: 5, username: nil, token: token, completion: { [weak self] (success, response) in
            if success {
                NSLog("load feed success \(response?.count ?? 0)")
                self?.nextURLString = response?.next
                DispatchQueue.main.async {
                    if let feeds = response?.feeds {
                        self?.dataSource.removeAll()
                        self?.dataSource = feeds.map({FTFeedViewModel(f: $0)})
                        self?.tableView.reloadData()
                        self?.tableView.addBotomActivityView {
                            self?.loadMore()
                        }
                    }
                    
                }
            } else {
                NSLog("load feed failure")
            }
        })
    }
    
    func loadMore() {
        guard let nextURL = self.nextURLString else {
            self.tableView.removeBottomActivityView()
            return
        }
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        self.rootViewController.coreService.webService?.loadMoreFeed(nextURL: nextURL, token: token, completion: { [weak self] (success, response) in
            if success {
                NSLog("load more feed successful \(response?.next ?? "")")
                self?.nextURLString = response?.next
                DispatchQueue.main.async {
                    if let feeds = response?.feeds {
                        if feeds.count > 0 {
                            self?.tableView.endBottomActivity()
                            
                            self?.dataSource.append(contentsOf: feeds.map({FTFeedViewModel(f: $0)}))
                            self?.tableView.reloadData()
                        }
                        else {
                            self?.tableView.removeBottomActivityView()
                        }
                    } else {
                        self?.tableView.removeBottomActivityView()
                    }
                }
            } else {
                self?.tableView.removeBottomActivityView()
            }
        })
        
    }
    
    // MARK: - Helpers
    private func setUpSegmentControl() {
        segmentedControl.segmentStyle = .imageOnly
        segmentedControl.insertSegment(withTitle: "Feed", image: UIImage(named: "feed_unselected"), at: 0)
        segmentedControl.insertSegment(withTitle: "Photos", image: UIImage(named: "photos_unselected"), at: 1)
        segmentedControl.insertSegment(withTitle: "Videos", image: #imageLiteral(resourceName: "videos_unselected2"), at: 2)
        segmentedControl.insertSegment(withTitle: "Articles", image: #imageLiteral(resourceName: "articles_unselected"), at: 3)
        segmentedControl.insertSegment(withTitle: "Music", image: #imageLiteral(resourceName: "music"), at: 4)
        segmentedControl.selectedSegmentContentColor = UIColor.navigationBarColor()
        segmentedControl.selectedSegmentIndex = 0
        
        //fixedWidthSwitch.isOn = false
        //segmentedControl.fixedSegmentWidth = fixedWidthSwitch.isOn
        
        let largerRedTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black]
        let largerRedTextHighlightAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.navigationBarColor()]
        let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.navigationBarColor()]
        
        segmentedControl.setTitleTextAttributes(largerRedTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(largerRedTextHighlightAttributes, for: .highlighted)
        segmentedControl.setTitleTextAttributes(largerRedTextSelectAttributes, for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        //refreshControl?.tintColor = UIColor.blue
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refreshControlValueChanged(_ sender: UIRefreshControl) {
        self.refreshControl?.endRefreshing()
        self.loadFeed()
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        switch sender.selectedSegmentIndex {
        case 2: // video
            let videoVC = FTFeedVideoCollectionViewController(coreService: rootViewController.coreService)
            self.navigationController?.pushViewController(videoVC, animated: true)
        default:
            break
        }
    }
    
    @objc func feedTabTouchAction() {
        guard tableView != nil else { return }
        if tableView.contentOffset.y > 0 {
            tableView.setContentOffset(.zero, animated: true)
        } else if tableView.contentOffset.y == 0 {
            guard rootViewController.coreService != nil else { return }
            let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
            hub.hide(animated: true, afterDelay: 1)
            self.loadFeed()
        }
    }

}

extension FTTabFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier()) as! FTFeedTableViewCell
        cell.delegate = self
        cell.renderCell(data: content)
        return cell
    }
}

extension FTTabFeedViewController: FTFeedCellDelegate {
    
    func feedCellDidTapUsername(username: String) {
        // TODO: open username
        let profileVC = FTTabProfileViewController(nibName: "FTTabProfileViewController", bundle: nil)
        profileVC.rootViewController = self.rootViewController
        profileVC.rootViewController.coreService = rootViewController.coreService
        profileVC.displayType = .user
        profileVC.username = username
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    func feeddCellGotoFeed(cell: FTFeedTableViewCell) {
        // TODO: goto feed
    }
    
    func feeddCellShare(cell: FTFeedTableViewCell) {
        // TODO: share
    }
    
    func feeddCellSeeLessContent(cell: FTFeedTableViewCell) {
        // TODO: see less content
    }
    
    func feeddCellReportInapproriate(cell: FTFeedTableViewCell) {
        // TODO: report inapproriate
    }
    
    func feeddCellEdit(cell: FTFeedTableViewCell) {
        // TODO: edit
    }
    
    func feeddCellPermanentlyDelete(cell: FTFeedTableViewCell) {
        // TODO: delete
        guard let feedID = cell.feed.id else { return }
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        progressHub = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHub?.detailsLabel.text = NSLocalizedString("Delete...", comment: "")
        self.rootViewController.coreService.webService?.deleteFeed(feedID: "\(feedID)", token: token, completion: { [weak self] (success, response) in
            if success {
                // Reload feed
                self?.dataSource = (self?.dataSource.filter { $0.feed.id != cell.feed.id })!
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.progressHub?.detailsLabel.text = NSLocalizedString("Successful", comment: "")
                    self?.progressHub?.hide(animated: true, afterDelay: 1)
                }
            } else {
                DispatchQueue.main.async {
                    self?.progressHub?.detailsLabel.text = NSLocalizedString("Failure", comment: "")
                    self?.progressHub?.hide(animated: true, afterDelay: 1)
                }
            }
        })
    }
    
    func feedCellDidChangeReactionType(cell: FTFeedTableViewCell) {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        
        guard let ct_id = cell.feed.id else { return }
        guard let ct_name = cell.feed.ct_name else { return }
        let react_type = cell.ftReactionType.rawValue
        rootViewController.coreService.webService?.react(token: token, ct_name: ct_name, ct_id: ct_id, react_type: react_type, completion: { (success, type) in
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
    
    func feedCellDidRemoveReaction(cell: FTFeedTableViewCell) {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        
        guard let ct_id = cell.feed.id else { return }
        guard let ct_name = cell.feed.ct_name else { return }
        rootViewController.coreService.webService?.removeReact(token: token, ct_name: ct_name, ct_id: ct_id, completion: { (success, msg) in
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
    
    func feedCellDidSave(cell: FTFeedTableViewCell) {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        
        guard let ct_id = cell.feed.id else { return }
        guard let ct_name = cell.feed.ct_name else { return }
        rootViewController.coreService.webService?.saveFeed(token: token, ct_name: ct_name, ct_id: ct_id, completion: { (success, message) in
            if success {
                NSLog("Save Feed successful ct_name: \(ct_name) ct_id: \(ct_id)")
            } else {
                NSLog("Save Feed failed ct_name: \(ct_name) ct_id: \(ct_id)")
                DispatchQueue.main.async {
                    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                    cell.feed.saved = false
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
    
    func feedCellDidUnSave(cell: FTFeedTableViewCell) {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        
        guard let ct_id = cell.feed.id else { return }
        guard let ct_name = cell.feed.ct_name else { return }
        rootViewController.coreService.webService?.removeSaveFeed(token: token, ct_name: ct_name, ct_id: ct_id, completion: { (success, message) in
            if success {
                NSLog("Remove saved Feed successful ct_name: \(ct_name) ct_id: \(ct_id)")
            } else {
                NSLog("Remove saved Feed failed ct_name: \(ct_name) ct_id: \(ct_id)")
                DispatchQueue.main.async {
                    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                    cell.feed.saved = true
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
    
    func feedCellDidTouchUpComment(cell: FTFeedTableViewCell) {
        // TODO: show comment view
        var comments: [FTCommentViewModel] = []
        guard let feed = cell.feed else { return }
        guard let coreService = self.rootViewController.coreService else { return }
        if let items = feed.comment?.comments {
            for item in items {
                let cmv = FTCommentViewModel(comment: item, type: .text)
                comments.append(cmv)
            }
        }
        
        let commentVC = CommentController(c: coreService, f: feed, comments: comments)
        commentVC.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.75)
        let popupController = STPopupController(rootViewController: commentVC)
        popupController.style = .bottomSheet
        popupController.present(in: self)
    }
}
