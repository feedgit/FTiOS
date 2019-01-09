//
//  ArticleTitleViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/9/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class ArticleTitleViewModel: BECellDataSource {
    static let cellID = "ArticleTitleTableViewCell"
    
    var title: String
    
    init(title t: String) {
        title = t
    }
    
    
    func cellIdentifier() -> String {
        return ArticleTitleViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return FTHelpers.textViewHeigh(text: title, font: UIFont.ArticleTitleFont(), width: UIScreen.main.bounds.width - 16)
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
}
