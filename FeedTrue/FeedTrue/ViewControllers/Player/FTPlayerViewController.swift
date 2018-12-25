//
//  FTPlayerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTPlayerViewController: UIViewController {
    @IBOutlet weak var player: BMCustomPlayer!
    var videoURL: URL
    fileprivate var saveImageView: UIImageView!
    fileprivate var commentImageView: UIImageView!
    fileprivate var loveImageView: UIImageView!
    fileprivate var avatarImageView: UIImageView!
    
    var feed: FTFeedInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Player", comment: "")
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        let asset = BMPlayerResource(url: videoURL,
                                     name: "",
                                     cover: nil,
                                     subtitle: nil)
        player.setVideo(resource: asset)
        
        configureActionView()
    }
    
    init(feed f: FTFeedInfo, videoURL url: URL) {
        feed = f
        videoURL = url
        super.init(nibName: "FTPlayerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureActionView() {
        let w = self.view.frame.width
        let h = self.view.frame.height
        saveImageView = UIImageView(image: UIImage(named: "save"))
        saveImageView.frame = CGRect(x: w, y: h - 100, width: 32, height: 32)
        
        commentImageView = UIImageView(image: UIImage(named: "comment"))
        commentImageView.frame = CGRect(x: w, y: h - 100 - 64, width: 32, height: 32)
        
        loveImageView = UIImageView(image: UIImage(named: "love"))
        loveImageView.frame = CGRect(x: w, y: h - 100 - 64*2, width: 32, height: 32)
        
        avatarImageView = UIImageView(frame: CGRect(x: w, y: h - 100 - 64*3, width: 32, height: 32))
        avatarImageView.round()
        if let avatarURLString = feed.user?.avatar {
            avatarImageView.loadImage(fromURL: URL(string: avatarURLString), defaultImage: UIImage.userImage())
        } else {
            avatarImageView = UIImageView(image: UIImage.userImage())
        }
        
        view.addSubview(saveImageView)
        view.addSubview(commentImageView)
        view.addSubview(loveImageView)
        view.addSubview(avatarImageView)
        
        let saveTap = UITapGestureRecognizer(target: self, action: #selector(savePressed(_:)))
        saveImageView.isUserInteractionEnabled = true
        saveImageView.addGestureRecognizer(saveTap)
        
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(commentPressed(_:)))
        commentImageView.isUserInteractionEnabled = true
        commentImageView.addGestureRecognizer(commentTap)
        
        let loveTap = UITapGestureRecognizer(target: self, action: #selector(lovePressed(_:)))
        loveImageView.isUserInteractionEnabled = true
        loveImageView.addGestureRecognizer(loveTap)
        
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(avatarPressed(_:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(avatarTap)
    }
    
    @objc func savePressed(_ sender: Any) {
        print(#function)
    }
    
    @objc func commentPressed(_ sender: Any) {
        print(#function)
    }
    
    @objc func lovePressed(_ sender: Any) {
        print(#function)
    }
    
    @objc func avatarPressed(_ sender: Any) {
        print(#function)
    }
    
    
    private func setRightButtonsHidden(hidden: Bool) {
        let alpha: CGFloat = hidden ? 0.0 : 1.0
        
        UIView.animate(withDuration: 0.35,
                       animations: { () -> Void in
                        self.saveImageView.alpha = alpha
                        self.commentImageView.alpha = alpha
                        self.loveImageView.alpha = alpha
                        self.avatarImageView.alpha = alpha
        }, completion: nil)
    }
}
