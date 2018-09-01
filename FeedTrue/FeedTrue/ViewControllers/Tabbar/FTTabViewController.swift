//
//  FTTabViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTTabViewController: UIViewController {
    weak var rootViewController: FeedTrueRootViewController!
    var cameraBarBtn: UIBarButtonItem!
    var messageBarBtn: UIBarButtonItem!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cameraBtn = UIButton.init(type: .custom)
        cameraBtn.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal), for: .normal)
        cameraBtn.addTarget(self, action: #selector(FTTabViewController.camera(sender:)), for: .touchUpInside)
        cameraBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.cameraBarBtn = UIBarButtonItem(customView: cameraBtn)
        //navigationController?.topViewController?.navigationItem.leftBarButtonItem = self.cameraBarBtn
        navigationItem.leftBarButtonItem = self.cameraBarBtn
        
        let messageBtn = UIButton.init(type: .custom)
        messageBtn.setImage(UIImage(named: "message")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageBtn.addTarget(self, action: #selector(FTTabViewController.message(sender:)), for: .touchUpInside)
        messageBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.messageBarBtn = UIBarButtonItem(customView: messageBtn)
        
        //navigationController?.topViewController?.navigationItem.rightBarButtonItem = self.messageBarBtn
        navigationItem.rightBarButtonItem = self.messageBarBtn
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @objc private func camera(sender: Any) -> () {
        
    }
    
    @objc private func message(sender: Any) -> () {
        
    }

}
