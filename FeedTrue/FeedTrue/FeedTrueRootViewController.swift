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

class FeedTrueRootViewController: UIViewController {
    
    private var customNavigationController: UINavigationController?
    var coreService: FTCoreService!
    var cameraBarBtn: UIBarButtonItem!
    var messageBarBtn: UIBarButtonItem!
    var searchTextField: UITextField!
    var progressHub: MBProgressHUD?
    var profileVC: FTTabProfileViewController!
    var feedVC: FTTabFeedViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(white: 245.0 / 255.0, alpha: 1.0)
        
        // navigation bar
        let nav = customIrregularityStyle(delegate: nil)
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0.0, vertical: -60), for: .default)
        nav.navigationBar.isTranslucent = true
        addChildViewController(nav)
        
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
        coreService = FTCoreService()
        coreService.setup()
        coreService.start()
        
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
        
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            if index == 0 {
                // Feed Tab
                NotificationCenter.default.post(name: .FeedTabTouchAction, object: nil)
            }
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

        let notificationVC = UIViewController()
        let composeVC = UIViewController()
        composeVC.view.backgroundColor = UIColor.backgroundColor()

        profileVC = FTTabProfileViewController(nibName: "FTTabProfileViewController", bundle: nil)
        profileVC.rootViewController = self
        profileVC.rootViewController.coreService = self.coreService

        let feedItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "feed_unselected"), selectedImage: UIImage(named: "feed_selected"))

        feedItem.contentView?.renderingMode = .alwaysOriginal
        feedItem.contentView?.backdropColor = UIColor.clear
        feedItem.contentView?.highlightBackdropColor = UIColor.clear
        feedVC.tabBarItem = feedItem

        let notificationItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "notification_unselected"), selectedImage: UIImage(named: "notification_selected"))
        notificationItem.contentView?.renderingMode = .alwaysOriginal
        notificationItem.contentView?.backdropColor = UIColor.clear
        notificationItem.contentView?.highlightBackdropColor = UIColor.clear
        notificationVC.tabBarItem = notificationItem

        let composeItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "compose"), selectedImage: UIImage(named: "compose"))
        composeItem.contentView?.renderingMode = .alwaysOriginal
        composeItem.contentView?.backdropColor = UIColor.clear
        composeItem.contentView?.highlightBackdropColor = UIColor.clear
        composeVC.tabBarItem = composeItem

        let profileItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "profile_unselected"), selectedImage: UIImage(named: "profile_selected"))
        profileItem.contentView?.renderingMode = .alwaysOriginal
        profileItem.contentView?.backdropColor = UIColor.clear
        profileItem.contentView?.highlightBackdropColor = UIColor.clear
        profileVC.tabBarItem = profileItem


        let settingVC = FTTabSettingsViewController(nibName: "FTTabSettingsViewController", bundle: nil)
        settingVC.rootViewController = self
        settingVC.rootViewController.coreService = self.coreService

        let settingItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "setting_unselected"), selectedImage: UIImage(named: "setting_selected"))
        settingItem.contentView?.renderingMode = .alwaysOriginal
        settingItem.contentView?.backdropColor = UIColor.clear
        settingItem.contentView?.highlightBackdropColor = UIColor.clear
        settingVC.tabBarItem = settingItem
        
        tabBarController.viewControllers = [feedVC, notificationVC, composeVC, profileVC, settingVC]
        feedtrueTabBarController = tabBarController

        let navigationController = UINavigationController.init(rootViewController: tabBarController)
        
        return navigationController
    }
    
    func showLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "loginScreen") as! LoginViewController
        signInVC.coreService = coreService
        signInVC.delegate = self
        self.navigationController?.present(signInVC, animated: true, completion: nil)
    }
    
    func silentlyLogin() {
            if let password = self.coreService.keychainService?.password(), !password.isEmpty, let username = self.coreService.keychainService?.username(), !username.isEmpty {
            //self.progressHub = MBProgressHUD.showAdded(to: self.view, animated: true)
            //self.progressHub?.detailsLabel.text = NSLocalizedString("Login...", comment: "")
            self.coreService.webService?.signIn(username: username, password: password, completion: { [weak self] (success, response) in
                //self?.progressHub?.hide(animated: true)
                if success {
                    self?.coreService.registrationService?.storeAuthProfile(response?.token, profile: response?.user)
                    self?.feedtrueTabBarController?.selectedIndex = 0
                    self?.feedVC.loadFeed()
                    self?.profileVC.loadUserInfo()
                } else {
                    // show login
                    DispatchQueue.main.async {
                        self?.showLogin()
                    }
                }
            })
        } else {
            self.showLogin()
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

}

extension FeedTrueRootViewController: LoginDelegate {
    func didLoginSuccess() {
        self.feedtrueTabBarController.selectedIndex = 0
        self.profileVC.loadUserInfo()
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
