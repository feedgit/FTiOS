//
//  FTUserDashBoardTabViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import MBProgressHUD

class FTUserDashBoardTabViewController: FTTabViewController {
    var dataSource: [[BECellDataSource]] = []
    var arrMenu: Array<Any> = []
    var countRow = 3
    var countCol = 4
    var progressHub: MBProgressHUD?
    
    @IBOutlet weak var tableView: UITableView!
    /*
     (lldb) po arrMenu[0] as! [String: String]
     ▿ 2 elements
     ▿ 0 : 2 elements
     - key : "title"
     - value : "Video"
     ▿ 1 : 2 elements
     - key : "image"
     - value : "ic_video"
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataSource = []
        FTUserDashBoardViewModel.register(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        
        generateDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let qrCodeBarBtn = UIBarButtonItem(image: UIImage(named: "ic_qr_code"), style: .plain, target: self, action: #selector(qrCodeAction))
        qrCodeBarBtn.tintColor = .white
        self.parent?.navigationItem.leftBarButtonItem = qrCodeBarBtn
        self.parent?.navigationItem.title = NSLocalizedString("Profile", comment: "")
        let followBarBtn = UIBarButtonItem(image: UIImage(named: "ic_who_to_follow"), style: .plain, target: self, action: #selector(followAction))
        followBarBtn.tintColor = .white
        self.parent?.navigationItem.rightBarButtonItem = followBarBtn
    }
    
    @objc func qrCodeAction() {
        
    }
    
    @objc func followAction() {
        
    }
    
    fileprivate func generateDatasource() {
        // section 0: profile
        let profile = FTUserDashBoardViewModel(type: .profile)
        dataSource.append([profile])
        
        // setion 1: follow
        let follow = FTUserDashBoardViewModel(type: .follow)
        dataSource.append([follow])
        
        // section 2: menu
        let saved = ["title": "Saved", "image": "saved"]
        let photo = ["title": "Photos", "image": "ic_photo"]
        let video = ["title": "Videos", "image": "ic_video"]
        let blog = ["title": "Blogs", "image": "ic_blog"]
        let travel = ["title": "Travel", "image": "ic_travel"]
        let wishlist = ["title": "Wishlist", "image": "ic_wishlist"]
        let gift = ["title": "Gifts", "image": "ic_gift"]
        let miab = ["title": "MIAB", "image": "ic_miab"]
        let store = ["title": "My Store", "image": "ic_my_store"]
        let statistic = ["title": "Statistics", "image": "ic_statistic"]
        arrMenu = [saved, photo, video, blog, travel, wishlist, gift, miab, store, statistic]
        let menu = FTUserDashBoardMenuViewModel(arr: arrMenu)
        dataSource.append([menu])
        
        // section 3: setting + logout
        let setting = FTUserDashBoardSettingViewModel(title: "Settings", icon: UIImage(named: "ic_setting")!)
        setting.settingType = .settings
        let logout = FTUserDashBoardSettingViewModel(title: "Log out", icon: UIImage(named: "ic_logout")!)
        logout.settingType = .logout
        
        dataSource.append([setting, logout])
        
    }

}

extension FTUserDashBoardTabViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            // menu
            let cell = tableView.dequeueReusableCell(withIdentifier: "FTMenuTableViewCell", for: indexPath) as! FTMenuTableViewCell
            cell.pgCtrlShouldHidden = true
            cell.pgCtrlNormalColor = .gray
            cell.pgCtrlSelectedColor = .black
            cell.countRow = countRow
            cell.countCol = countCol
            cell.arrMenu = arrMenu
            //cell.delegate = self
            return cell
        }
        let content = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        
        if let settingCell = cell as? FTUserDashBoardSettingCell {
            settingCell.delegate = self
        }
        
        if let editingCell = cell as? BECellRender {
            editingCell.renderCell(data: content)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                return (UIScreen.main.bounds.size.width / CGFloat(countCol)) * CGFloat(countRow) + 10
            }
            else {
                return 50.0
            }
        }
        let content = dataSource[indexPath.section][indexPath.row]
        return content.cellHeight()
    }
}

extension FTUserDashBoardTabViewController: UserDashBoardSettingDelegate {
    func userDashBoardSettingDidTouchUpAction(type: SettingType) {
        switch type {
        case .settings:
            break
        case .logout:
            logout()
        }
    }
    
    func logout() {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // user cancel
        }
        
        let logoutAction = UIAlertAction(title: NSLocalizedString("Log Out", comment: ""), style: .default) { [weak self] (action) in
            DispatchQueue.main.async {
                self?.progressHub = MBProgressHUD.showAdded(to: self!.view, animated: true)
                self?.progressHub?.detailsLabel.text = NSLocalizedString("Log Out ...", comment: "")
                self?.progressHub?.show(animated: true)
                self?.rootViewController.coreService.webService?.logOut(token: token, completion: { (success, message) in
                    self?.progressHub?.hide(animated: true)
                    if success {
                        DispatchQueue.main.async {
                            self?.rootViewController.showLogin()
                            self?.rootViewController.coreService.registrationService?.reset()
                            self?.rootViewController.coreService.keychainService?.reset()
                        }
                    } else {
                        self?.rootViewController.showLogin()
                        self?.rootViewController.coreService.registrationService?.reset()
                        self?.rootViewController.coreService.keychainService?.reset()
                    }
                })
            }
        }
        
        FTAlertViewManager.defaultManager.showActions("Log Out", message: "Are you sure you wan to log out?", actions: [cancelAction, logoutAction], view: self.view)
        
    }
}
