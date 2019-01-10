//
//  ArticleReactionViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/10/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class ArticleReactionViewModel: BECellDataSource {
    static let cellID = "ReactionsBottomTableViewCell"
    
    var article: FTArticleContent
    
    init(article a: FTArticleContent) {
        article = a
    }
    
    
    func cellIdentifier() -> String {
        return ArticleReactionViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 32
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
}
