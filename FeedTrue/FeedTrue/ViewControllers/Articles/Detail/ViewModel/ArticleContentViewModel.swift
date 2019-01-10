//
//  ArticleContentViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/10/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class ArticleContentViewModel: BECellDataSource {
    static let cellID = "ArticleContentTableViewCell"
    
    var content: String
    
    init(content c: String) {
        content = c
    }
    
    
    func cellIdentifier() -> String {
        return ArticleContentViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return FTHelpers.textViewHeigh(text: content.htmlToString, font: UIFont.contentFont(), width: UIScreen.main.bounds.width - 16)
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
}
