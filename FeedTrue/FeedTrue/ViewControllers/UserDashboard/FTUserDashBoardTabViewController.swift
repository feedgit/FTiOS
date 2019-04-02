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
    var profile: FTUserProfileResponse?
    var refreshControl: UIRefreshControl?
    
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
        tableView.register(FTMenuTableViewCell.self, forCellReuseIdentifier: "FTMenuTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        generateDatasource()
        //self.loadUserInfo()
        setUpRefreshControl()
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
        let explore = ["title": "Explore", "image": "feed_selected"]
        let travel = ["title": "Travel", "image": "ic_travel"]
        let chat = ["title": "Chats", "image": "ic_message_selected"]
        let photo = ["title": "Photos", "image": "ic_photo"]
        let video = ["title": "Videos", "image": "ic_video"]
        
        let blog = ["title": "Blogs", "image": "ic_blog"]
        let miab = ["title": "MIAB", "image": "ic_miab"]
        let saved = ["title": "Saved", "image": "saved"]
        let statistic = ["title": "Statistics", "image": "ic_statistic"]
        
        let setting = ["title": "Settings", "image": "ic_setting"]
        let logout = ["title": "Log out", "image": "ic_logout"]
        arrMenu = [explore, travel, chat, photo, video, blog, miab, saved, statistic, setting, logout]
//
//        let explore = FTUserDashBoardMenuViewModel(title: "Explore", icon: UIImage(named: "feed_selected")!)
//
//        let travel = FTUserDashBoardMenuViewModel(title: "Travel", icon: UIImage(named: "ic_travel")!)
//
//        let chat = FTUserDashBoardMenuViewModel(title: "Chats", icon: UIImage(named: "ic_message_selected")!)
//
//        let photo = FTUserDashBoardMenuViewModel(title: "Photos", icon: UIImage(named: "ic_photo")!)
//
//        let video = FTUserDashBoardMenuViewModel(title: "Videos", icon: UIImage(named: "ic_video")!)
//
//        let blog = FTUserDashBoardMenuViewModel(title: "Blogs", icon: UIImage(named: "ic_blog")!)
//
//        let miab = FTUserDashBoardMenuViewModel(title: "MIAB", icon: UIImage(named: "ic_miab")!)
//
//
//        let saved = FTUserDashBoardMenuViewModel(title: "Saved", icon: UIImage(named: "saved")!)
//
//        let statistic = FTUserDashBoardMenuViewModel(title: "Statistics", icon: UIImage(named: "ic_statistic")!)
//
//        dataSource.append([explore, travel, chat, photo, video, blog, miab, store, saved, statistic])
        
        // section 3: setting + logout
//        let setting = FTUserDashBoardSettingViewModel(title: "Settings", icon: UIImage(named: "ic_setting")!)
//        setting.settingType = .settings
//        dataSource.append([setting])
//        let logout = FTUserDashBoardSettingViewModel(title: "Log out", icon: UIImage(named: "ic_logout")!)
//        logout.settingType = .logout
//
//        dataSource.append([logout])
        
    }
    
    @objc func loadUserInfo() {
        guard let username = rootViewController.coreService.registrationService?.authenticationProfile?.profile?.username else { return }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        rootViewController.coreService.webService?.getUserInfo(username: username, completion: {[weak self] (success, response) in
            if success {
                self?.profile = response
                DispatchQueue.main.async {
                    self?.updateUI()
                    guard let v = self?.view else { return }
                    MBProgressHUD.hide(for: v, animated: true)
                }
            } else {
                NSLog("\(#function) FAILURE")
                guard let v = self?.view else { return }
                MBProgressHUD.hide(for: v, animated: true)
            }
            
        })
    }
    
    fileprivate func updateUI() {
        if let p = profile {
            if let profileVM = dataSource[0][0] as? FTUserDashBoardViewModel {
                profileVM.profile = p
            }
            
            if let followVM = dataSource[1][0] as? FTUserDashBoardViewModel {
                followVM.profile = p
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        //refreshControl?.tintColor = UIColor.blue
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refreshControlValueChanged(_ sender: UIRefreshControl) {
        self.refreshControl?.endRefreshing()
        loadUserInfo()
    }

}

extension FTUserDashBoardTabViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == dataSource.count {
            return 1
        }
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 { // last section
            let cell = tableView.dequeueReusableCell(withIdentifier: "FTMenuTableViewCell", for: indexPath) as! FTMenuTableViewCell
            cell.pgCtrlShouldHidden = true
            cell.pgCtrlNormalColor = .gray
            cell.pgCtrlSelectedColor = .black
            cell.countRow = countRow
            cell.countCol = countCol
            cell.arrMenu = arrMenu
            cell.delegate = self
            return cell
        }
        
        let content = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        
        if let settingCell = cell as? FTUserDashBoardSettingCell {
            settingCell.delegate = self
            if indexPath.section == 3 || indexPath.section == 4 {
                cell.layer.cornerRadius = 8
            } else {
                cell.layer.cornerRadius = 0
            }
        }
        
        if let profileCell = cell as? FTUserDashBoardProfileCell {
            profileCell.delegate = self
        }
        
        if let editingCell = cell as? BECellRender {
            editingCell.renderCell(data: content)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                return (UIScreen.main.bounds.size.width / CGFloat(countCol)) * CGFloat(countRow) + 4
            }
            else {
                return 50.0
            }
        }
        
        let content = dataSource[indexPath.section][indexPath.row]
        return content.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 3 || section == 4 {
//            return 4
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == dataSource.count - 1 {
//            return 4
//        } else {
//            return 0
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // profile
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                // explorer
                NotificationCenter.default.post(name: .SelectTabBarAtIndex, object: TabType.explore)
            } else if indexPath.row == 5 {
                // show blog
                let articleVC = FTArticlesViewController(coreService: rootViewController.coreService)
                self.navigationController?.pushViewController(articleVC, animated: true)
            } else if indexPath.row == 4 {
                let videoVC = FTFeedVideoCollectionViewController(coreService: rootViewController.coreService)
                //videoVC.delegate = self
                self.navigationController?.pushViewController(videoVC, animated: true)
            }
        }
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
            NSLog("return")
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
                            self?.rootViewController.loadDefaultData()
                            self?.rootViewController.coreService.registrationService?.reset()
                            self?.rootViewController.coreService.keychainService?.reset()
                        }
                    } else {
                        self?.rootViewController.loadDefaultData()
                        self?.rootViewController.coreService.registrationService?.reset()
                        self?.rootViewController.coreService.keychainService?.reset()
                    }
                })
            }
        }
        
        FTAlertViewManager.defaultManager.showActions("Log Out", message: "Are you sure you wan to log out?", actions: [cancelAction, logoutAction], view: self.view)
        
    }
}

extension FTUserDashBoardTabViewController: FTUserDashBoardProfileCellDelegate {
    func userSelected() {
        // TODO: open username
        let profileVC = FTTabProfileViewController(nibName: "FTTabProfileViewController", bundle: nil)
        profileVC.rootViewController = self.rootViewController
        profileVC.rootViewController.coreService = rootViewController.coreService
        profileVC.displayType = .owner
        profileVC.username = nil
        profileVC.profile = profile
        profileVC.delegate = self
        self.navigationController?.pushViewController(profileVC, animated: true)

    }
}

extension FTUserDashBoardTabViewController: ProfileDelegate {
    func avatarDidChange(avatar: String) {
        profile?.avatar = avatar
        updateUI()
    }
}

extension FTUserDashBoardTabViewController: FTMenuTableViewCellDelegate {
    func menuTableViewCell(_ menuCell: FTMenuTableViewCell, didSelectedItemAt index: Int) {
        NSLog("\(#function) at index: \(index)")
        if index == 0 {
            // explorer
            NotificationCenter.default.post(name: .SelectTabBarAtIndex, object: TabType.explore)
        } else if index == 5 {
            // show blog
            let articleVC = FTArticlesViewController(coreService: rootViewController.coreService)
            self.navigationController?.pushViewController(articleVC, animated: true)
        } else if index == 4 {
            let videoVC = FTFeedVideoCollectionViewController(coreService: rootViewController.coreService)
            //videoVC.delegate = self
            self.navigationController?.pushViewController(videoVC, animated: true)
        } else if index == 11 {
            logout()
        } else if index == 10 {
            // open setting
            let settingVC = FTSettingsViewController()
            self.navigationController?.pushViewController(settingVC, animated: true)
        }

    }
}
