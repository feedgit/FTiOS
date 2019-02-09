//
//  FTRichTextViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/31/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTRichTextViewModel: BECellDataSource {
    static let cellID = "FTRichTextTableViewCell"
    func cellIdentifier() -> String {
        return FTRichTextViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        if enable {
            return UIScreen.main.bounds.height / 3
        }
        return 0
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    var content: String
    init(content c: String) {
        content = c
    }
    
    var enable: Bool = true
}
