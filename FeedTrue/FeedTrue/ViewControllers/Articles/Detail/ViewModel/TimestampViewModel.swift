//
//  TimestampViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/10/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class TimestampViewModel: BECellDataSource {
    
    static let cellID = "ArticleTimestampTableViewCell"
    var timestamp: String
    
    init(timestamp t: String) {
        timestamp = t
    }
    
    func cellIdentifier() -> String {
        return TimestampViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 32
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
}
