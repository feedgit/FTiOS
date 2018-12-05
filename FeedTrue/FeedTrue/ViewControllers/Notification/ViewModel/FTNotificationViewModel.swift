//
//  FTNotificationViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTNotificationViewModel: BECellDataSource {
    static let cellId = "FTNotificationTableViewCell"
    var content: FTNotificationItem
    
    init(content c: FTNotificationItem) {
        content = c
    }
    
    func cellIdentifier() -> String {
        return FTNotificationViewModel.cellId
    }
    
    func cellHeight() -> CGFloat {
        return 64
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
}
