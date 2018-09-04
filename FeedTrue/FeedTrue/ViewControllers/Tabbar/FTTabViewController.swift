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
