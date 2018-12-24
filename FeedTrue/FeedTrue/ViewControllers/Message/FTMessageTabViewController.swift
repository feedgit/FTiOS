//
//  FTMessageTabViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/12/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import MBProgressHUD

class FTMessageTabViewController: FTTabViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: [BECellDataSource] = []
    var refreshControl: UIRefreshControl?
    var nextURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = []
        FTContactViewModel.register(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.videoVCBackGroundCollor()
        loadContact()
        setUpRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = NSLocalizedString("Message", comment: "")
        self.parent?.navigationItem.leftBarButtonItem = nil
        self.parent?.navigationItem.rightBarButtonItem = nil
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refreshControlValueChanged(_ sender: UIRefreshControl) {
        self.refreshControl?.endRefreshing()
        loadContact()
    }
    
    func loadContact() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        rootViewController.coreService.webService?.getContact(completion: { [weak self] (success, contactResponse) in
            if success {
                NSLog("\(#function) load contact successful")
                self?.dataSource.removeAll()
                self?.appedDataSource(contactResponse: contactResponse)
                DispatchQueue.main.async {
                    if let _ = contactResponse?.contacts, let _ = contactResponse?.next {
                        self?.tableView.addBotomActivityView {
                            self?.loadMore()
                        }
                    }
                }
            } else {
                NSLog("\(#function) load contact failed")
            }
            DispatchQueue.main.async {
                guard let v = self?.view else { return }
                MBProgressHUD.hide(for: v, animated: true)
            }
        })
    }
    
    func appedDataSource(contactResponse: FTContactResponse?) {
        if let nextURLString = contactResponse?.next {
            self.nextURL = nextURLString
        } else {
            self.nextURL = nil
        }
        
        guard let contacts = contactResponse?.contacts else { return }
        for contact in contacts {
            let vm = FTContactViewModel(contact: contact)
            dataSource.append(vm)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadMore() {
        guard let nextURLString = nextURL else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        rootViewController.coreService.webService?.getMoreContact(nextString: nextURLString, completion: { [weak self] (success, contactResponse) in
            if success {
                NSLog("\(#function) load more contact successful")
                self?.appedDataSource(contactResponse: contactResponse)
                DispatchQueue.main.async {
                    if contactResponse?.next == nil {
                        self?.tableView.removeBottomActivityView()
                    } else {
                        self?.tableView.endBottomActivity()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.tableView.endBottomActivity()
                }
                
                NSLog("\(#function) load more contact failed")
            }
            DispatchQueue.main.async {
                guard let v = self?.view else { return }
                MBProgressHUD.hide(for: v, animated: true)
            }
        })
    }
}

extension FTMessageTabViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = dataSource[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        if let editingCell = cell as? BECellRender {
            editingCell.renderCell(data: content)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = dataSource[indexPath.section]
        return content.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let chatDataSource = DemoChatDataSource(count: 0, pageSize: 0)
//        let viewController = DemoChatViewController()
        let contactVM = dataSource[indexPath.row] as! FTContactViewModel
//        viewController.contact = contact.contact
//        viewController.dataSource = chatDataSource
//        self.navigationController?.pushViewController(viewController, animated: true)
        let chatView = ChatViewController()
        //chatView.messages = makeNormalConversation()
        chatView.contact = contactVM.contact
        self.navigationController?.pushViewController(chatView, animated: true)
    }
}
