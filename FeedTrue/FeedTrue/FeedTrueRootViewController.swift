//
//  FeedTrueRootViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/30/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import MBProgressHUD

public enum TabType: Int {
    case dashboard = 0
    case explore = 1
    case notification = 2
    case chat = 3
    case search = 4
}

class FeedTrueRootViewController: UIViewController {
    
    private var customNavigationController: UINavigationController?
    var coreService: FTCoreService!
    var cameraBarBtn: UIBarButtonItem!
    var messageBarBtn: UIBarButtonItem!
    var searchTextField: UITextField!
    var progressHub: MBProgressHUD?
    var profileVC: FTTabProfileViewController!
    var userDashBoardVC: FTUserDashBoardTabViewController!
    var notificationVC: FTNotificationTabViewController!
    var feedVC: FTTabFeedViewController!
    
    var messageItem: ESTabBarItem!
    var notificationItem: ESTabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(white: 245.0 / 255.0, alpha: 1.0)
        
        // navigation bar
        let nav = customIrregularityStyle(delegate: nil)
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0.0, vertical: -60), for: .default)
        nav.navigationBar.isTranslucent = true
        addChild(nav)
        
        nav.beginAppearanceTransition(true, animated: false)
        view.addSubview(nav.view)
        nav.endAppearanceTransition()
        customNavigationController = nav
        let cameraBtn = UIButton.init(type: .custom)
        cameraBtn.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal), for: .normal)
        cameraBtn.addTarget(self, action: #selector(camera(_:)), for: .touchUpInside)
        cameraBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.cameraBarBtn = UIBarButtonItem(customView: cameraBtn)
        //navigationController?.topViewController?.navigationItem.leftBarButtonItem = self.cameraBarBtn
        
        let messageBtn = UIButton.init(type: .custom)
        messageBtn.setImage(UIImage(named: "ic_add")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageBtn.addTarget(self, action: #selector(message(_:)), for: .touchUpInside)
        messageBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        self.messageBarBtn = UIBarButtonItem(customView: messageBtn)
        customNavigationController?.topViewController?.navigationItem.rightBarButtonItem = self.messageBarBtn
        
        // search text field
        searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 21))
        searchTextField.placeholder = NSLocalizedString("Search", comment: "")
        searchTextField.returnKeyType = .done
        searchTextField.textColor = .black
        searchTextField.backgroundColor = .white
        searchTextField.borderStyle = .roundedRect
        searchTextField.delegate = self
        //customNavigationController?.topViewController?.navigationItem.titleView = searchTextField
        customNavigationController?.topViewController?.navigationItem.title = NSLocalizedString("FeedTrue", comment: "")
        
        // services
        coreService = FTCoreService.share
        coreService.setup()
        coreService.start()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLogin), name: .ShowLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectAtIndex(notification:)), name: .SelectTabBarAtIndex, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !coreService.isLogged() {
            // silently sign in
            silentlyLogin()
        }
    }
    
    override var navigationController: UINavigationController? {
        get {
            return customNavigationController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    fileprivate var feedtrueTabBarController: ESTabBarController!
    func customIrregularityStyle(delegate: UITabBarControllerDelegate?) -> UINavigationController {
        let tabBarController = ESTabBarController()
        tabBarController.delegate = delegate
        tabBarController.tabBar.backgroundColor = .white
        // remove top border line
        tabBarController.tabBar.clipsToBounds = true
        
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
//            if index == 2 {
//                return true
//            }
            if index == 1 {
                // Feed Tab
                NotificationCenter.default.post(name: .FeedTabTouchAction, object: nil)
            }
            
//            if index == 4 {
//                // user dashboard tab
//                if self.coreService.registrationService?.hasAuthenticationProfile() == false {
//                    NotificationCenter.default.post(name: .ShowLogin, object: nil)
//                }
//            }
            return false
        }
        
//        tabBarController.didHijackHandler = {
//            void in
//            print("didHijackHandler")
//        }
//
        feedVC = FTTabFeedViewController(nibName: "FTTabFeedViewController", bundle: nil)
        feedVC.rootViewController = self
        feedVC.rootViewController.coreService = self.coreService
        feedVC.view.backgroundColor = UIColor.backgroundColor()

        let messageVC = FTMessageTabViewController(nibName: "FTMessageTabViewController", bundle: nil)
        messageVC.rootViewController = self
        messageVC.rootViewController.coreService = self.coreService
        
        // Notification TAB
        notificationVC = FTNotificationTabViewController(nibName: "FTNotificationTabViewController", bundle: nil)
        notificationVC.rootViewController = self
        notificationVC.rootViewController.coreService = self.coreService
        
        //FTUserDashBoardTabViewController
        userDashBoardVC = FTUserDashBoardTabViewController(nibName: "FTUserDashBoardTabViewController", bundle: nil)
        userDashBoardVC.rootViewController = self
        userDashBoardVC.rootViewController.coreService = self.coreService
        
        profileVC = FTTabProfileViewController(nibName: "FTTabProfileViewController", bundle: nil)
        profileVC.rootViewController = self
        profileVC.rootViewController.coreService = self.coreService

        let feedItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "feed_unselected"), selectedImage: UIImage(named: "feed_selected"))

        feedItem.contentView?.renderingMode = .alwaysOriginal
        feedItem.contentView?.backdropColor = UIColor.clear
        feedItem.contentView?.highlightBackdropColor = UIColor.clear
        feedVC.tabBarItem = feedItem

        notificationItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "notification_unselected"), selectedImage: UIImage(named: "notification_selected"))
        notificationItem.contentView?.renderingMode = .alwaysOriginal
        notificationItem.contentView?.backdropColor = UIColor.clear
        notificationItem.contentView?.highlightBackdropColor = UIColor.clear
        notificationVC.tabBarItem = notificationItem
        
        messageItem = ESTabBarItem(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "ic_message"), selectedImage: UIImage(named: "ic_message_selected"))
        messageItem.contentView?.renderingMode = .alwaysOriginal
        messageItem.contentView?.backdropColor = .clear
        messageItem.contentView?.highlightBackdropColor = .clear
        messageVC.tabBarItem = messageItem

        let profileItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "ic_user"), selectedImage: UIImage(named: "ic_user_selected"))
        profileItem.contentView?.renderingMode = .alwaysOriginal
        profileItem.contentView?.backdropColor = UIColor.clear
        profileItem.contentView?.highlightBackdropColor = UIColor.clear
        profileVC.tabBarItem = profileItem
        userDashBoardVC.tabBarItem = profileItem


        let searchVC = FTTabSettingsViewController(nibName: "FTTabSettingsViewController", bundle: nil)
        searchVC.rootViewController = self
        searchVC.rootViewController.coreService = self.coreService

        let settingItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "ic_search"), selectedImage: UIImage(named: "ic_search_selected"))
        settingItem.contentView?.renderingMode = .alwaysOriginal
        settingItem.contentView?.backdropColor = UIColor.clear
        settingItem.contentView?.highlightBackdropColor = UIColor.clear
        searchVC.tabBarItem = settingItem
        
        tabBarController.viewControllers = [userDashBoardVC, feedVC, notificationVC, messageVC, searchVC]
        feedtrueTabBarController = tabBarController

        let navigationController = UINavigationController.init(rootViewController: tabBarController)
        
        return navigationController
    }
    
    @objc func showLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "loginScreen") as! LoginViewController
        signInVC.coreService = coreService
        signInVC.delegate = self
        self.navigationController?.present(signInVC, animated: true, completion: nil)
    }
    
    @objc func selectAtIndex(notification: NSNotification) {
        NSLog(notification.name.rawValue)
        if let type = notification.object as? TabType {
            self.feedtrueTabBarController.selectedIndex = type.rawValue
        }
    }
    
    func loadDefaultData() {
        self.feedtrueTabBarController?.selectedIndex = 0
        self.feedVC.loadFeed()
        self.profileVC.loadUserInfo()
        self.userDashBoardVC.loadUserInfo()
        self.getActivities()
    }
    
    func silentlyLogin() {
        if let password = self.coreService.keychainService?.password(), !password.isEmpty, let username = self.coreService.keychainService?.username(), !username.isEmpty {
            //self.progressHub = MBProgressHUD.showAdded(to: self.view, animated: true)
            //self.progressHub?.detailsLabel.text = NSLocalizedString("Login...", comment: "")
            self.coreService.webService?.signIn(username: username, password: password, completion: { [weak self] (success, response) in
                //self?.progressHub?.hide(animated: true)
                if success {
                    self?.coreService.registrationService?.storeAuthProfile(response?.token, profile: response?.user)
                    //                    self?.feedtrueTabBarController?.selectedIndex = 0
                    //                    self?.feedVC.loadFeed()
                    //                    self?.profileVC.loadUserInfo()
                } else {
                    // show login
                    //                    DispatchQueue.main.async {
                    //                        self?.showLogin()
                    //                    }
                }
                self?.loadDefaultData()
            })
        } else {
            loadDefaultData()
        }
    }
    
    // MARK: Actions
    @objc func message(_ sender: Any) {
        
    }
    
    @objc func camera(_ sender: Any) {
        
    }
    
    // MARK: - Helpers
    @objc func singleTapHandler(_ sender: Any?) {
        self.view.endEditing(true)
    }
    
    fileprivate func getActivities() {
        WebService.share.getActivities { (success, activitiesResponse) in
            if success {
                NSLog(activitiesResponse.debugDescription)
                if let messageCount = activitiesResponse?.message_room_count, messageCount > 0 {
                    self.messageItem.badgeValue = "\(messageCount)"
                } else {
                    self.messageItem.badgeValue = nil
                }
                
                if let notificationCount = activitiesResponse?.notification_count, notificationCount > 0 {
                    self.notificationItem.badgeValue = "\(notificationCount)"
                } else {
                    self.notificationItem.badgeValue = nil
                }
            }
        }
    }

}

extension FeedTrueRootViewController: LoginDelegate {
    func didLoginSuccess() {
        self.feedtrueTabBarController.selectedIndex = 0
        self.profileVC.loadUserInfo()
        self.userDashBoardVC.loadUserInfo()
        self.feedVC.loadFeed()
    }
    
    func didLoginFailure() {
        
    }
}

extension FeedTrueRootViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.endEditing(true)
        return true
    }
}
