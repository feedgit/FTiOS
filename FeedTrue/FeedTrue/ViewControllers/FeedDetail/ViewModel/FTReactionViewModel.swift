//
//  FTReactionViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/30/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTReactionViewModel: BECellDataSource {
    static let cellID = "FTReactionTableViewCell"
    func cellIdentifier() -> String {
        return FTReactionViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 50
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    
    var reaction: FTReactData
    init(reaction r: FTReactData) {
        reaction = r
    }
}
