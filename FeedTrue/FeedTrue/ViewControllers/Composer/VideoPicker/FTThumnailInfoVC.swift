//
//  FTThumnailInfoVC.swift
//  FeedTrue
//
//  Created by Quoc Le on 3/30/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTThumnailInfoVC: UIViewController {
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var videoURL: URL
    
    init(videoURL url: URL) {
        videoURL = url
        super.init(nibName: "FTThumnailInfoVC", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let addTap = UITapGestureRecognizer(target: self, action: #selector(addThumbnail(_:)))
        addImageView.isUserInteractionEnabled = true
        addImageView.addGestureRecognizer(addTap)
    }
    
    @objc func addThumbnail(_ sender: UIImageView) {
        
    }

}
