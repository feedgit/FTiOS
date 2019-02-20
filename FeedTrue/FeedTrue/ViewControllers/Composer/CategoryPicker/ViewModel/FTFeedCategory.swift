//
//  FTFeedCategory.swift
//  FeedTrue
//
//  Created by Quoc Le on 2/20/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTFeedCategory: BECellDataSource {
    static let cellID = "FTCategoryTableViewCell";
    func cellIdentifier() -> String {
        return FTFeedCategory.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 64
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    var key: Int
    var label: String
    var icon: UIImage?
    var background: UIColor
    var description: String
    
    init(key k: Int, label lb: String, iconName ic: String, background bg: String, description des: String) {
        key = k
        label = lb
        icon = UIImage(named: ic)
        background = UIColor(hexString: bg)
        description = des
    }
}
