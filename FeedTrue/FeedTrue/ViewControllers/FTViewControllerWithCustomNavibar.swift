//
//  FTViewControllerWithCustomNavibar.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTViewControllerWithCustomNavibar: UIViewController {
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var navibarHeightConstraint: NSLayoutConstraint!
    var customNaviItem = UINavigationItem()
    
    private var mainBarHiddenStatus = true
    private var didUpdateMainBarHiddenStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if customNaviItem != naviBar.topItem  {
            naviBar.pushItem(customNaviItem, animated: true)
        }
        
        if !didUpdateMainBarHiddenStatus, let mainNavi = navigationController {
            mainBarHiddenStatus = mainNavi.isNavigationBarHidden
            didUpdateMainBarHiddenStatus = true
        }
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed || isMovingFromParentViewController {
            navigationController?.setNavigationBarHidden(mainBarHiddenStatus, animated: true)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let statusHeight = UIApplication.shared.statusBarFrame.maxY
        let naviHeight = statusHeight + (navigationController?.navigationBar.frame.size.height ?? 44)
        
        
        navibarHeightConstraint.constant = naviHeight
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

}
