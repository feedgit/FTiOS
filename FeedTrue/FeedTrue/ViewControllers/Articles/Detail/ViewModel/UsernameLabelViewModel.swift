//
//  UsernameLabelViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/10/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class UsernameLabelViewModel: BECellDataSource {
    static let cellID = "UsernameLabelTableViewCell"
    
    var user: UserProfile
    
    init(user u: UserProfile) {
        user = u
    }
    
    func cellIdentifier() -> String {
        return UsernameLabelViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 24
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
}

