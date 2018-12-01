//
//  FTBottomReactionViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTBottomReactionViewModel: BECellDataSource {
    static let cellID = "FTBottomReactionTableViewCell"
    func cellIdentifier() -> String {
        return FTBottomReactionViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 44
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    var ftReactionType: FTReactionTypes = .love
    
    init(reactionType type: FTReactionTypes) {
        ftReactionType = type
    }
}
