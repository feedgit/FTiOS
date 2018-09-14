//
//  FTTabFeedViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl

class FTTabFeedViewController: FTTabViewController {
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [FTFeedInfo]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = []
        tableView.register(UINib(nibName: "FTFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FTFeedTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        
        self.setUpSegmentControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadFeed() {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        self.rootViewController.coreService.webService?.getFeed(page: 1, per_page: 5, username: nil, token: token, completion: { [weak self] (success, response) in
            if success {
                NSLog("load feed success \(response?.count ?? 0)")
                DispatchQueue.main.async {
                    if let feeds = response?.feeds {
                        self?.dataSource = feeds
                        self?.tableView.reloadData()
                    }
                    
                }
            } else {
                NSLog("load feed failure")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FTFeedTableViewCell") as! FTFeedTableViewCell
        let info = dataSource[indexPath.row]
        if let urlString = info.user?.avatar?.data?.imageURL {
            if let url = URL(string: urlString) {
                cell.userAvatarImageview.loadImage(fromURL: url)
            }
        }
        cell.nameLabel.text = info.user?.full_name
        cell.dateLabel.text = info.date
        cell.feedContentTextview.text = info.text?.htmlToString
        return cell
    }
}
