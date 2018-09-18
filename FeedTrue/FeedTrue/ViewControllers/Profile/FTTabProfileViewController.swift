//
//  FTTabProfileViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import MBProgressHUD
import ScrollableSegmentedControl

class FTTabProfileViewController: FTTabViewController {

    var profile: FTUserProfileResponse?
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var feedsLabel: UILabel!
    @IBOutlet weak var photoVideoLabel: UILabel!
    @IBOutlet weak var likedLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpSegmentControl()
        avatarImageView.round()
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
        editVC.delegate = self
        
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func addFriend(_ sender: Any) {
        // TODO: follow/unfollow or Edit profile
    }
    
    @objc func loadUserInfo() {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else { return }
        guard let username = rootViewController.coreService.registrationService?.authenticationProfile?.profile?.username else { return }

        MBProgressHUD.showAdded(to: self.view, animated: true)
        rootViewController.coreService.webService?.getUserInfo(token: token, username: username, completion: {[weak self] (success, response) in
            if success {
                self?.profile = response
                DispatchQueue.main.async {
                    self?.updateProfileInfo()
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
    
    private func updateProfileInfo() {
        feedsLabel.text = "\(profile?.feed_count ?? 0)"
        photoVideoLabel.text = "\(profile?.photo_video_count ?? 0)"
        likedLabel.text = "\(profile?.loved ?? 0)"
        fullnameLabel.text = profile?.full_name
        introLabel.text = profile?.intro
        if let urlString = profile?.avatar {
            if let url = URL(string: urlString) {
                avatarImageView.loadImage(fromURL: url)
            }
        }
    }
    
    private func resetUserInfoUI() {
        feedsLabel.text = ""
        photoVideoLabel.text = ""
        likedLabel.text = ""
        fullnameLabel.text = ""
        introLabel.text = ""
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
    }
    
    private func setUpSegmentControl() {
        segmentedControl.segmentStyle = .imageOnTop
        segmentedControl.insertSegment(withTitle: "Feed", image: #imageLiteral(resourceName: "feed_unselected"), at: 0)
        segmentedControl.insertSegment(withTitle: "About", image: #imageLiteral(resourceName: "profile_selected"), at: 1)
        segmentedControl.insertSegment(withTitle: "Photos", image: #imageLiteral(resourceName: "photos_unselected"), at: 2)
        segmentedControl.insertSegment(withTitle: "Videos", image: #imageLiteral(resourceName: "videos_unselected2"), at: 3)
        segmentedControl.insertSegment(withTitle: "Articles", image: #imageLiteral(resourceName: "articles_unselected"), at: 4)
        
        //segmentedControl.underlineSelected = true
        segmentedControl.selectedSegmentIndex = 1
        //fixedWidthSwitch.isOn = false
        //segmentedControl.fixedSegmentWidth = fixedWidthSwitch.isOn
        
        let largerRedTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black]
        let largerRedTextHighlightAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.navigationBarColor()]
        let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.navigationBarColor()]
        
        segmentedControl.setTitleTextAttributes(largerRedTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(largerRedTextHighlightAttributes, for: .highlighted)
        segmentedControl.setTitleTextAttributes(largerRedTextSelectAttributes, for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
    }
    
}

extension FTTabProfileViewController: FTEditProfileDelegate {
    func didSaveSuccessful() {
        DispatchQueue.main.async {
            self.resetUserInfoUI()
            self.loadUserInfo()
        }
    }
    
    func didSaveFailure() {
        
    }
}
