//
//  FTNotificationTabViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import MBProgressHUD

class FTNotificationTabViewController: FTTabViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [BECellDataSource] = []
    var refreshControl: UIRefreshControl?
    var nextURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = []
        FTNotificationViewModel.register(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.backgroundColor()
        
        loadNotification()
        setUpRefreshControl()
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refreshControlValueChanged(_ sender: UIRefreshControl) {
        self.refreshControl?.endRefreshing()
        loadNotification()
    }
    
    func loadNotification() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        rootViewController.coreService.webService?.getNotification(completion: { [weak self] (success, notificationResponse) in
            if success {
                NSLog("\(#function) load notification successful")
                self?.dataSource.removeAll()
                self?.appedDataSource(notificationResponse: notificationResponse)
                DispatchQueue.main.async {
                    if let _ = notificationResponse?.notifications {
                        self?.tableView.addBotomActivityView {
                            self?.loadMore()
                        }
                    }
                }
            } else {
                NSLog("\(#function) load notification failed")
            }
            DispatchQueue.main.async {
                guard let v = self?.view else { return }
                MBProgressHUD.hide(for: v, animated: true)
            }
        })
    }
    
    func appedDataSource(notificationResponse: FTNotificationResponse?) {
        if let nextURLString = notificationResponse?.next {
            self.nextURL = nextURLString
        } else {
            self.nextURL = nil
        }
        
        guard let notifications = notificationResponse?.notifications else { return }
        for item in notifications {
            let vm = FTNotificationViewModel(content: item)
            dataSource.append(vm)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadMore() {
        guard let nextURLString = nextURL else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        rootViewController.coreService.webService?.getMoreNotification(nextString: nextURLString, completion: { [weak self] (success, notificationResponse) in
            if success {
                NSLog("\(#function) load more notification successful")
                self?.appedDataSource(notificationResponse: notificationResponse)
                DispatchQueue.main.async {
                    if let notifications = notificationResponse?.notifications {
                        if notifications.count > 0 {
                            self?.tableView.endBottomActivity()
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
                NSLog("\(#function) load more notification failed")
            }
            DispatchQueue.main.async {
                guard let v = self?.view else { return }
                MBProgressHUD.hide(for: v, animated: true)
            }
        })
    }
}


extension FTNotificationTabViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        if let editingCell = cell as? BECellRender {
            editingCell.renderCell(data: content)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = dataSource[indexPath.row]
        return content.cellHeight()
    }
}
