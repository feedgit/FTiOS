//
//  FTTabFeedViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTTabFeedViewController: FTTabViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadFeed()
    }
    

    private func loadFeed() {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        self.rootViewController.coreService.webService?.getFeed(page: 1, per_page: 5, username: nil, token: token, completion: { (success, response) in
            if success {
                NSLog("load feed success \(response?.count ?? 0)")
            } else {
                NSLog("load feed failure")
            }
        })
    }

}
