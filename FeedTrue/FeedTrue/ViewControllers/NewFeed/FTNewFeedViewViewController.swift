//
//  FTNewFeedViewViewController.swift
//  FeedTrue
//
//  Created by Le Cong Toan on 4/9/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTNewFeedViewViewController: UIViewController {

    @IBOutlet weak var NewFeedNavigator: UIView!
    var FeedNavi : CAPSPageMenu?
    var NaviArray : [UIViewController] = []
    
    // Initialize newfeed navigator
    func initNewFeedNavi () {
        let FollowingVC = MansoryFeedCollectionViewController(collectionViewLayout: PinterestLayout())
        FollowingVC.title = "Following"
        FollowingVC.fetchExploreFeed()
        
        let ExploreVC = FTTabFeedViewController(nibName: "FTTabFeedViewController", bundle: nil)
        ExploreVC.title = "Explore"
        let parameters: [CAPSPageMenuOption] = [
            .selectedMenuItemLabelColor(.black),
            .unselectedMenuItemLabelColor(.gray),
            .scrollMenuBackgroundColor(.white),
            .menuItemFont(UIFont.pageMenuFont())
        ]
        
        NaviArray = [FollowingVC, ExploreVC]
        FeedNavi = CAPSPageMenu(viewControllers: NaviArray, frame: CGRect(x: 0, y: 0, width: NewFeedNavigator.frame.width, height: NewFeedNavigator.frame.height), pageMenuOptions: parameters)
        
        self.NewFeedNavigator.addSubview(FeedNavi!.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initNewFeedNavi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.navigationItem.leftBarButtonItem = nil
        self.parent?.navigationItem.title = "Home"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
