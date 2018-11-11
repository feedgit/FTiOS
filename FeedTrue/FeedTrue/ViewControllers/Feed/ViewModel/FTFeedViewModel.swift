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
    var imageHeight: CGFloat = (UIScreen.main.bounds.width - 16) * 9 / 16
    var commentHeight: CGFloat = 0
    init(f: FTFeedInfo) {
        feed = f
    }
    
    func cellIdentifier() -> String {
        return FTFeedViewModel.feedCellId
    }
    
    func cellHeight() -> CGFloat {
        return 180.0 + imageHeight + commentHeight
        
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: feedCellId, bundle: nil), forCellReuseIdentifier: feedCellId)
    }
}
