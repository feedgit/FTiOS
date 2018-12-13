//
//  FTContactViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/12/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTContactViewModel: BECellDataSource {
    static let cellID = "FTContactTableViewCell"
    var contact: FTContact
    
    init(contact c: FTContact) {
        contact = c
    }
    
    func cellIdentifier() -> String {
        return FTContactViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 64
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    

}
