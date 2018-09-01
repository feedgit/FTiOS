//
//  FeedTrueRootViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/30/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class FeedTrueRootViewController: UIViewController {
    
    private var customNavigationController: UINavigationController?
    var coreService: FTCoreService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(white: 245.0 / 255.0, alpha: 1.0)
        let nav = customIrregularityStyle(delegate: nil)
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0.0, vertical: -60), for: .default)
        nav.navigationBar.isTranslucent = true
        addChildViewController(nav)
        
        nav.beginAppearanceTransition(true, animated: false)
        view.addSubview(nav.view)
        nav.endAppearanceTransition()
        customNavigationController = nav
        
        coreService = FTCoreService()
        coreService.setup()
        coreService.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !coreService.isLogged() {
            showLogin()
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
            return false
        }
        
//        tabBarController.didHijackHandler = {
//            void in
//            print("didHijackHandler")
//        }
//
        let feedVC = UIViewController()
        feedVC.view.backgroundColor = UIColor.gray

        let notificationVC = UIViewController()
        let composeVC = UIViewController()
        composeVC.view.backgroundColor = UIColor.clear

        let profileVC = FTTabProfileViewController(nibName: "FTTabProfileViewController", bundle: nil)
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


        let settingVC = UIViewController()

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
        self.navigationController?.present(signInVC, animated: true, completion: nil)
    }

}
