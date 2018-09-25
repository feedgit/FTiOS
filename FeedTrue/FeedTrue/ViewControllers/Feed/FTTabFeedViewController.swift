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
        guard let nextURL = self.nextURLString else { return }
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
                        self?.tableView.removeFromSuperview()
                    }
                }
            } else {
                self?.tableView.removeFromSuperview()
            }
        })
        
    }
    
    // MARK: - Helpers
    private func setUpSegmentControl() {
        segmentedControl.segmentStyle = .imageOnTop
        segmentedControl.insertSegment(withTitle: "Feed", image: UIImage(named: "feed_unselected")?.withRenderingMode(.alwaysOriginal), at: 0)
        segmentedControl.insertSegment(withTitle: "Photos", image: UIImage(named: "photos_unselected")?.withRenderingMode(.alwaysOriginal), at: 1)
        segmentedControl.insertSegment(withTitle: "Videos", image: #imageLiteral(resourceName: "videos_unselected2"), at: 2)
        segmentedControl.insertSegment(withTitle: "Articles", image: #imageLiteral(resourceName: "articles_unselected"), at: 3)
        segmentedControl.insertSegment(withTitle: "Music", image: #imageLiteral(resourceName: "music"), at: 4)
        
        //segmentedControl.underlineSelected = true
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
}
