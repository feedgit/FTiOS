//
//  FTDetailFileViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/3/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTDetailFileViewModel: BECellDataSource {
    static let cellId = "FTDetailFileTableViewCell"
    var feed: FTFeedInfo
    var commentHeight: CGFloat = 0
    init(f: FTFeedInfo) {
        feed = f
    }
    
    func cellIdentifier() -> String {
        return FTDetailFileViewModel.cellId
    }
    
    func cellHeight() -> CGFloat {
        return 44
        
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
}
