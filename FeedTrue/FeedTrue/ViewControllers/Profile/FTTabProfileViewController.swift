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
import YAScrollSegmentControl

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

@objc protocol ProfileDelegate {
    func avatarDidChange(avatar: String)
}

class FTTabProfileViewController: FTTabViewController {

    weak var delegate: ProfileDelegate?
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
    
    //@IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    
    //@IBOutlet weak var segment: YAScrollSegmentControl!
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var pageMenuView: UIView!
    var pageMenu : CAPSPageMenu?
    // Array to keep track of controllers in page menu
    var controllerArray : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        avatarImageView.round()
        followBtn.defaultBorder()
        if displayType == .user {
            let leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(popView))
            leftBarButton.tintColor = .white
            navigationItem.leftBarButtonItem = leftBarButton
            self.loadUserInfoWithUsername(username: username!)
        } else {
            self.updateProfileInfo()
        }
        
        self.avatarImageView.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(editAvatar))
        self.avatarImageView.addGestureRecognizer(singleTap)
        
        // image pikcer
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        setStyle()
        setupPageMenu()
    }
    
    func setStyle() {
        feedsLabel.font = UIFont.countLabelFont()
        photoVideoLabel.font = UIFont.countLabelFont()
        likedLabel.font = UIFont.countLabelFont()
        
    }
    
    func setupPageMenu() {
        let homeVC = FTTabFeedViewController(nibName: "FTTabFeedViewController", bundle: nil)
        homeVC.feedViewMode = .username
        homeVC.username = username
        homeVC.title = username
        homeVC.loadFeed()
        
        let aboutVC = UIViewController()
        aboutVC.title = "About"
        aboutVC.view.backgroundColor = .gray
        
        let photosVC = UIViewController()
        photosVC.title = "Photos"
        photosVC.view.backgroundColor = .gray
        
        let videosVC = FTTagViewController(coreService: FTCoreService.share)
        videosVC.username = username
        videosVC.title = "Videos"
        
        
        let blogsVC = FTArticlesViewController(coreService: FTCoreService.share)
        blogsVC.username = username
        blogsVC.title = "Blogs"
        
        controllerArray = [homeVC, aboutVC, photosVC, videosVC, blogsVC]
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .selectedMenuItemLabelColor(.black),
            .unselectedMenuItemLabelColor(.gray),
            .scrollMenuBackgroundColor(.white),
            .menuItemFont(UIFont.pageMenuFont())
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: pageMenuView.frame.width, height: pageMenuView.frame.height), pageMenuOptions: parameters)
        
        self.pageMenuView.addSubview(pageMenu!.view)
        self.pageMenuView.layer.borderColor = UIColor.black.cgColor
        self.pageMenuView.layer.borderWidth = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = UIColor.navigationTitleTextColor()
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("About", comment: "")
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                    guard let username = self?.profile?.username else { return }
                    MBProgressHUD.showAdded(to: self?.view ?? UIView(), animated: true)
                    self?.followBtn.setTitle(NSLocalizedString(FollowState.secret_following.rawValue, comment: ""), for: .normal)
                    self?.rootViewController.coreService.webService?.secretFollow(username: username, completion: { [weak self] (success, message) in
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
                    guard let username = self?.profile?.username else { return }
                    MBProgressHUD.showAdded(to: self?.view ?? UIView(), animated: true)
                    self?.followBtn.setTitle(NSLocalizedString(FollowState.following.rawValue, comment: ""), for: .normal)
                    self?.rootViewController.coreService.webService?.follow(username: username, completion: { [weak self] (success, message) in
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
                guard let username = profile?.username else { return }
                MBProgressHUD.showAdded(to: self.view, animated: true)
                followBtn.setTitle(NSLocalizedString(FollowState.follow.rawValue, comment: ""), for: .normal)
                rootViewController.coreService.webService?.unfollow(username: username, completion: { [weak self] (success, message) in
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
        guard let username = rootViewController.coreService.registrationService?.authenticationProfile?.profile?.username else { return }

        MBProgressHUD.showAdded(to: self.view, animated: true)
        rootViewController.coreService.webService?.getUserInfo(username: username, completion: {[weak self] (success, response) in
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
        MBProgressHUD.showAdded(to: self.view, animated: true)
        rootViewController.coreService.webService?.getUserInfo(username: username, completion: {[weak self] (success, response) in
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
        fullnameLabel.text = p.username
        introLabel.text = p.bio
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
            followBtn.setTitle(NSLocalizedString("Follow", comment: ""), for: .normal)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // dismiss picker view controller
        self.dismiss(animated: true, completion: nil)
        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        let circleCropController = YKCircleCropViewController()
        circleCropController.image = image
        circleCropController.delegate = self
        present(circleCropController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadAvatar(image: UIImage) {
        rootViewController.coreService.webService?.uploadAvatar(image: image, completion: { (success, avatar) in
            if success {
                // TODO: save new avatar
                NSLog("\(#function) upload avatart successful")
                self.profile?.avatar = avatar
                if let a = avatar {
                    self.delegate?.avatarDidChange(avatar: a)
                }
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

extension FTTabProfileViewController: YAScrollSegmentControlDelegate {
    func didSelectItem(at index: Int) {
        print("\(#function) index: \(index)")
    }
    
    
}
