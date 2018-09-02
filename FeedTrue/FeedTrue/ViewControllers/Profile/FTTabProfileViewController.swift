//
//  FTTabProfileViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import MBProgressHUD

class FTTabProfileViewController: FTTabViewController {

    var profile: FTUserProfileResponse?
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var feedsLabel: UILabel!
    @IBOutlet weak var photoVideoLabel: UILabel!
    @IBOutlet weak var likedLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.resetUserInfoUI()
        self.loadUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - IBActions

    @IBAction func edit(_ sender: Any) {
        let editVC = FTEditProfileViewController(nibName: "FTEditProfileViewController", bundle: nil)
        editVC.coreService = rootViewController.coreService
        editVC.profile = profile
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func addFriend(_ sender: Any) {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        rootViewController.coreService.webService?.logOut(token: token, completion: {[weak self] (success, message) in
            if success {
                DispatchQueue.main.async {
                    self?.rootViewController.showLogin()
                    self?.rootViewController.coreService.registrationService?.reset()
                    self?.resetUserInfoUI()
                }
            } else {
                // TODO: show error message
                DispatchQueue.main.async {
                    self?.rootViewController.showLogin()
                    self?.rootViewController.coreService.registrationService?.reset()
                    self?.resetUserInfoUI()
                }
            }
        })
    }
    
    private func loadUserInfo() {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else { return }
        guard let username = rootViewController.coreService.registrationService?.authenticationProfile?.profile?.username else { return }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        rootViewController.coreService.webService?.getUserInfo(token: token, username: username, completion: {[weak self] (success, response) in
            self?.profile = response
            DispatchQueue.main.async {
                self?.updateProfileInfo()
                guard let v = self?.view else { return }
                MBProgressHUD.hide(for: v, animated: true)
            }
        })
    }
    private func updateProfileInfo() {
        feedsLabel.text = "\(profile?.feed_count ?? 0)"
        photoVideoLabel.text = "\(profile?.photo_video_count ?? 0)"
        likedLabel.text = "\(profile?.loved ?? 0)"
        fullnameLabel.text = profile?.full_name
        introLabel.text = profile?.email
    }
    
    private func resetUserInfoUI() {
        feedsLabel.text = ""
        photoVideoLabel.text = ""
        likedLabel.text = ""
        fullnameLabel.text = ""
        introLabel.text = ""
    }
    
}
