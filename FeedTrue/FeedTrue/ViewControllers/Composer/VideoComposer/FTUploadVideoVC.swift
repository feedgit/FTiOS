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
    var asset: DKAsset
    // Array to keep track of controllers in page menu
    var controllerArray : [UIViewController] = []

    init(asset a: DKAsset) {
        asset = a
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
        let videosVC = UIViewController()
        videosVC.title = "Videos"
        videosVC.view.backgroundColor = .green
        
        let infoVC = UIViewController()
        infoVC.title = "Info"
        infoVC.view.backgroundColor = .gray
        
        let thumbnaiVC = UIViewController()
        thumbnaiVC.title = "Thumbnail"
        thumbnaiVC.view.backgroundColor = .blue
        
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
        self.navigationController?.popViewController(animated: false)
    }
   
}
