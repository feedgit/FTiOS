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
import YKPhotoCircleCrop

enum ProfileDisplayType {
    case owner
    case user
}

enum FollowState: String {
    case follow_back = "Follow Back"
    case following = "Following"
    case secret_following = "Secret Following"
    case follow = "Follow"
}

class FTTabProfileViewController: FTTabViewController {

    var profile: FTUserProfileResponse?
    var displayType: ProfileDisplayType = .owner
    var followState: FollowState = .follow
    var username: String?
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var feedsLabel: UILabel!
    @IBOutlet weak var photoVideoLabel: UILabel!
    @IBOutlet weak var likedLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    
    var imagePicker: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpSegmentControl()
        avatarImageView.round()
        followBtn.defaultBorder()
        if displayType == .user {
            let leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(popView))
            leftBarButton.tintColor = .white
            navigationItem.leftBarButtonItem = leftBarButton
            self.loadUserInfoWithUsername(username: username!)
        }
        
        self.avatarImageView.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(editAvatar))
        self.avatarImageView.addGestureRecognizer(singleTap)
        
        // image pikcer
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    @objc func editAvatar() {
        let takePhotoAction = UIAlertAction(title: NSLocalizedString("Take a photo", comment: ""), style: .default) { (action) in
            // TODO: take a photo
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraCaptureMode = .photo
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let chooseFromGalleryAction = UIAlertAction(title: NSLocalizedString("Choose from gallery", comment: ""), style: .default) { (action) in
            // TODO: choose from gallery
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default) { (action) in
            // TODO: delete avatar
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (action) in
            // TODO: cancel action
        }
        
        FTAlertViewManager.defaultManager.showActions(nil, message: nil, actions: [takePhotoAction, chooseFromGalleryAction, deleteAction, cancelAction], view: self.view)
    }
    
    @objc func popView() {
        self.navigationController?.popViewController(animated: true)
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

    @IBAction func followOrEdit(_ sender: Any) {
        switch displayType {
        case .owner:
            let editVC = FTEditProfileViewController(nibName: "FTEditProfileViewController", bundle: nil)
            editVC.coreService = rootViewController.coreService
            editVC.delegate = self
            
            navigationController?.pushViewController(editVC, animated: true)
        case .user:
            switch followState {
            case .follow_back, .follow:
                // TODO: call follow API
                let secretFollowAction = UIAlertAction(title: NSLocalizedString("Secret Follow", comment: ""), style: .default) { [weak self] (action) in
                    // TODO: secret follow API
                    guard let token = self?.rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else { return }
                    guard let username = self?.profile?.username else { return }
                    MBProgressHUD.showAdded(to: self?.view ?? UIView(), animated: true)
                    self?.followBtn.setTitle(NSLocalizedString(FollowState.secret_following.rawValue, comment: ""), for: .normal)
                    self?.rootViewController.coreService.webService?.secretFollow(token: token, username: username, completion: { [weak self] (success, message) in
                        if success {
                            // update status
                            self?.followState = .secret_following
                            DispatchQueue.main.async {
                                guard let v = self?.view else { return }
                                MBProgressHUD.hide(for: v, animated: true)
                            }
                        } else {
                            // revert status
                            DispatchQueue.main.async {
                                self?.followBtn.setTitle(NSLocalizedString(self?.followState.rawValue ?? "", comment: ""), for: .normal)
                                guard let v = self?.view else { return }
                                MBProgressHUD.hide(for: v, animated: true)
                            }
                        }
                    })
                }
                
                let followAction = UIAlertAction(title: NSLocalizedString("Folow", comment: ""), style: .default) { [weak self] (action) in
                    // TODO: follow API
                    guard let token = self?.rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else { return }
                    guard let username = self?.profile?.username else { return }
                    MBProgressHUD.showAdded(to: self?.view ?? UIView(), animated: true)
                    self?.followBtn.setTitle(NSLocalizedString(FollowState.following.rawValue, comment: ""), for: .normal)
                    self?.rootViewController.coreService.webService?.follow(token: token, username: username, completion: { [weak self] (success, message) in
                        if success {
                            // update status
                            self?.followState = .secret_following
                            DispatchQueue.main.async {
                                guard let v = self?.view else { return }
                                MBProgressHUD.hide(for: v, animated: true)
                            }
                        } else {
                            // revert status
                            DispatchQueue.main.async {
                                self?.followBtn.setTitle(NSLocalizedString(self?.followState.rawValue ?? "", comment: ""), for: .normal)
                                guard let v = self?.view else { return }
                                MBProgressHUD.hide(for: v, animated: true)
                            }
                        }
                    })
                }
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                
                FTAlertViewManager.defaultManager.showActions(nil, message: nil, actions: [secretFollowAction, followAction, cancelAction], view: self.view)
            case .secret_following, .following:
                guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else { return }
                guard let username = profile?.username else { return }
                MBProgressHUD.showAdded(to: self.view, animated: true)
                followBtn.setTitle(NSLocalizedString(FollowState.follow.rawValue, comment: ""), for: .normal)
                rootViewController.coreService.webService?.unfollow(token: token, username: username, completion: { [weak self] (success, message) in
                    if success {
                        // update status
                        self?.followState = .follow
                        DispatchQueue.main.async {
                            guard let v = self?.view else { return }
                            MBProgressHUD.hide(for: v, animated: true)
                        }
                    } else {
                        // revert status
                        DispatchQueue.main.async {
                            self?.followBtn.setTitle(NSLocalizedString(self?.followState.rawValue ?? "", comment: ""), for: .normal)
                            guard let v = self?.view else { return }
                            MBProgressHUD.hide(for: v, animated: true)
                        }
                    }
                })
            }
            
        }
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
    
    @objc func loadUserInfoWithUsername(username: String) {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else { return }
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
        guard let p = profile else { return }
        feedsLabel.text = "\(p.feed_count ?? 0)"
        photoVideoLabel.text = "\(p.photo_video_count ?? 0)"
        likedLabel.text = "\(p.loved ?? 0)"
        fullnameLabel.text = p.full_name
        introLabel.text = p.intro
        if let urlString = p.avatar {
            if let url = URL(string: urlString) {
                avatarImageView.loadImage(fromURL: url, defaultImage: UIImage.userImage())
            } else {
                avatarImageView.image = UIImage.userImage()
            }
        } else {
            avatarImageView.image = UIImage.userImage()
        }
        
        if p.isEditable() {
            followBtn.setTitle(NSLocalizedString("Edit Profile", comment: ""), for: .normal)
        } else {
            if p.isFollowedByViewer() && p.getFollowType() == .follow_back {
                followState = .follow_back
            } else {
                switch p.getFollowType() {
                case .follow_back:
                    followState = .follow
                case .following:
                    followState = .following
                case .secret_following:
                    followState = .secret_following
                }
            }
            followBtn.setTitle(NSLocalizedString(followState.rawValue, comment: ""), for: .normal)
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
        segmentedControl.segmentStyle = .imageOnly
        segmentedControl.insertSegment(withTitle: "Feed", image: #imageLiteral(resourceName: "feed_unselected"), at: 0)
        segmentedControl.insertSegment(withTitle: "About", image: #imageLiteral(resourceName: "profile_selected"), at: 1)
        segmentedControl.insertSegment(withTitle: "Photos", image: #imageLiteral(resourceName: "photos_unselected"), at: 2)
        segmentedControl.insertSegment(withTitle: "Videos", image: #imageLiteral(resourceName: "videos_unselected2"), at: 3)
        segmentedControl.insertSegment(withTitle: "Articles", image: #imageLiteral(resourceName: "articles_unselected"), at: 4)
        segmentedControl.selectedSegmentContentColor = UIColor.navigationBarColor()
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

extension FTTabProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // dismiss picker view controller
        self.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let circleCropController = YKCircleCropViewController()
        circleCropController.image = image
        circleCropController.delegate = self
        present(circleCropController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadAvatar(image: UIImage) {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else { return }
        
        rootViewController.coreService.webService?.uploadAvatar(token: token, image: image, completion: { (success, response) in
            if success {
                // TODO: save new avatar
                NSLog("\(#function) upload avatart successful")
            } else {
                // TODO: rollback
                NSLog("\(#function) upload avatar failure")
                self.avatarImageView.loadImage(fromURL: URL(string: self.profile?.avatar ?? ""), defaultImage: UIImage.defaultImage())
            }
        })
    }
}

extension FTTabProfileViewController: YKCircleCropViewControllerDelegate {
    func circleCropDidCancel() {
        print("User canceled the crop flow")
    }
    
    func circleCropDidCropImage(_ image: UIImage) {
        avatarImageView.image = image
        uploadAvatar(image: image)
    }
}
