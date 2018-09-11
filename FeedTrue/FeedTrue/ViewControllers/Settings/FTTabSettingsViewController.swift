//
//  FTTabSettingsViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/7/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DTGradientButton
import MBProgressHUD

class FTTabSettingsViewController: FTTabViewController {
    @IBOutlet weak var signOutBtn: UIButton!
    var progressHub: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    private func setupButtons() {
        let colors = [UIColor.navigationBarColor(), UIColor.navigationBarColor(alpha: 0.5)]
        signOutBtn.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
        signOutBtn.defaultBorder()
        signOutBtn.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - IBActions
    
    @IBAction func signOut(_ sender: Any) {
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
