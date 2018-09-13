//
//  FTTabFeedViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTTabFeedViewController: FTTabViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [FTFeedInfo]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = []
        tableView.register(UINib(nibName: "FTFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FTFeedTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadFeed()
    }
    

    private func loadFeed() {
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
        cell.feedContentTextview.text = info.text
        return cell
    }
}
