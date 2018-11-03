//
//  FTPrivacyPickerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/29/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

enum PrivacyIconName: String {
    case `public` = "privacy_public"
    case `private` = "privacy_private"
    case follow = "privacy_follow"
}

@objc protocol PrivacyPickerDelegate {
    func privacyDidSave(vc: FTPrivacyPickerViewController)
}

class FTPrivacyPickerViewController: UIViewController {
    weak var delegate: PrivacyPickerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var datasource: [FTPrivacyViewModel] = []
    var selectedPrivacy: FTPrivacy?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        generateDatasource()
        tableView.dataSource = self
        tableView.delegate = self
        FTPrivacyViewModel.register(tableView: tableView)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Choose Privacy", comment: "")
        
        /*
         let saveBarBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save(_:)))
        saveBarBtn.tintColor = .white
        navigationItem.rightBarButtonItem = saveBarBtn
        */
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func save(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func generateDatasource() {
        let privacyPublic = FTPrivacyViewModel(privace: FTPrivacy(title: NSLocalizedString("PUBLIC", comment: ""), detail: NSLocalizedString("Everyone can see this", comment: ""), imageName: PrivacyIconName.public.rawValue))
        
        let privacyPrivate = FTPrivacyViewModel(privace: FTPrivacy(title: NSLocalizedString("PRIVATE", comment: ""), detail: NSLocalizedString("Only you can see this", comment: ""), imageName: PrivacyIconName.private.rawValue))
        
        let privacyFollower = FTPrivacyViewModel(privace: FTPrivacy(title: NSLocalizedString("FOLLOWER", comment: ""), detail: NSLocalizedString("People who follow you can see this", comment: ""), imageName: PrivacyIconName.follow.rawValue))
        
        datasource = [privacyPublic, privacyPrivate, privacyFollower]
    }
}

extension FTPrivacyPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = datasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier()) as! FTPrivacyPickerTableViewCell
        cell.renderCell(data: content)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPrivacy = datasource[indexPath.row].privacy
        self.delegate?.privacyDidSave(vc: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = datasource[indexPath.row]
        return content.cellHeight()
    }
    
}
