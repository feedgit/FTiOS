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
    var imageHeight: CGFloat = 0
    var commentHeight: CGFloat = 0
    init(f: FTFeedInfo) {
        feed = f
    }
    
    func cellIdentifier() -> String {
        return FTFeedViewModel.feedCellId
    }
    
    func cellHeight() -> CGFloat {
        return 240.0 + imageHeight + commentHeight
        
    }
    
    func ratiosizeFirstThumbnail () -> CGSize {
        guard let feedcontent = feed.feedcontent else { return CGSize(width: 0, height: 0) }
        guard let img = feedcontent.data![0]["file"] as? [String: Any] else { return CGSize(width: 0, height: 0) }
        let width = img["width"] as! Int
        let height = img["height"] as! Int
        return CGSize(width: width, height: height)
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: feedCellId, bundle: nil), forCellReuseIdentifier: feedCellId)
    }
}
