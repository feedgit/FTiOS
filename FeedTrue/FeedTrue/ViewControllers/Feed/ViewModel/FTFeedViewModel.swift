//
//  FTFeedViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/20/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTFeedViewModel: BECellDataSource {
    static let feedCellId = "FTFeedTableViewCell"
    var feed: FTFeedInfo
    
    init(f: FTFeedInfo) {
        feed = f
    }
    
    func cellIdentifier() -> String {
        return FTFeedViewModel.feedCellId
    }
    
    func cellHeight() -> CGFloat {
        /*
         96 + // avatar view
         44 + // text: 2 lines
         50 + // collection view
         44 + // love|comment
         44 + // write comment
         200 + // comment view
         8*5 // vertical space
         */
        return 96 + 44 + 50 + 44 + 44 + 200 + 40
        
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: feedCellId, bundle: nil), forCellReuseIdentifier: feedCellId)
    }
}
