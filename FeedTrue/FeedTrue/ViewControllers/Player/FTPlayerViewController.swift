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
//        let token = FTKeyChainService.shared.accessToken()
//        let header = ["Authorization": "JWT \(token ?? "")"]
//
//        let definition = BMPlayerResourceDefinition(url: videoURL,
//                                                    definition: "definition",
//                                                    options: header)
//
//        let asset = BMPlayerResource(name: "Video Name",
//                                     definitions: [definition])
        player.setVideo(resource: asset)
    }
    
    init(videoURL url: URL) {
        videoURL = url
        super.init(nibName: "FTPlayerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
