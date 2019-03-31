//
//  FTUploadVideoVC.swift
//  FeedTrue
//
//  Created by Quoc Le on 3/23/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController

class FTUploadVideoVC: UIViewController {

    @IBOutlet weak var pageMenuView: UIView!
    var pageMenu : CAPSPageMenu?
    var videoURL: URL
    var videosVC: FTComposerVidepPlayerVC!
    var infoVC: FTUploadVideoInfoVC!
    var thumbnaiVC: FTThumnailInfoVC!
    // Array to keep track of controllers in page menu
    var controllerArray : [UIViewController] = []

    init(videoURL url: URL) {
        videoURL = url
        super.init(nibName: "FTUploadVideoVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupPageMenu()
    }
    
    func setupPageMenu() {
        videosVC = FTComposerVidepPlayerVC(videoURL: videoURL)
        videosVC.title = "Videos"
        
        infoVC = FTUploadVideoInfoVC()
        infoVC.title = "Info"
        
        thumbnaiVC = FTThumnailInfoVC(videoURL: videoURL)
        thumbnaiVC.title = "Thumbnail"
        
        controllerArray = [videosVC, infoVC, thumbnaiVC]
        
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
        navigationItem.title = NSLocalizedString("Upload Video", comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(next(_:)))
        nextBarBtn.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = nextBarBtn
    }

    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func next(_ sender: Any) {
        guard let thumbnail = thumbnaiVC.thumbnail, thumbnail != nil else {
            return
        }
        
        guard let titleInfo = infoVC.infoTitle, !titleInfo.isEmpty else {
            self.view.showToast("Please enter your title info")
            return
        }
        
        guard let desInfo = infoVC.infoDescription, !desInfo.isEmpty else {
            self.view.showToast("Please enter your description info")
            return
        }
        
        self.navigationController?.popViewController(animated: false)
        
        // TODO: call back with data to post
    }
   
}

extension UIView {
    
    func showToast(_ message: String) {
        let container = UIToolbar()
        container.layer.cornerRadius = 5
        container.clipsToBounds = true
        
        let toastLabel = UILabel()
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = UIColor.clear
        toastLabel.textColor = UIColor.darkText
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        
        let margin = CGFloat(20)
        let padding = CGFloat(10)
        
        let size = toastLabel.sizeThatFits(CGSize(width: self.bounds.width - margin * 2 - padding * 2, height: 200))
        container.frame = CGRect(x: (self.bounds.width - size.width) / 2,
                                 y: (self.bounds.height - size.height) / 2,
                                 width: size.width + padding,
                                 height: size.height + padding)
        
        toastLabel.frame = CGRect(x: 0, y: 0, width: container.bounds.width, height: container.bounds.height)
        container.addSubview(toastLabel)
        
        self.addSubview(container)
        
        UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
            container.alpha = 0.0
        }, completion: {(isCompleted) in
            container.removeFromSuperview()
        })
    }
}
