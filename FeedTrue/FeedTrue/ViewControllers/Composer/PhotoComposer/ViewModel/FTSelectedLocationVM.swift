//
//  FTSelectedLocationVM.swift
//  FeedTrue
//
//  Created by Quoc Le on 2/24/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTSelectedLocationVM: BECellDataSource {
    static let cellID = "FTSelectedLocationTableViewCell"
    
    func cellIdentifier() -> String {
        return FTSelectedLocationVM.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 64
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    var locationProperties: FTLocationProperties
    init(location: FTLocationProperties) {
        locationProperties = location
    }
    
}
