//
//  FTAriticleViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/19/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTAriticleViewModel: BECellDataSource {
    static let articleCellId = "FTAriticleTableViewCell"
    var article: FTArticleContent
    init(a: FTArticleContent) {
        article = a
    }
    
    func cellIdentifier() -> String {
        return FTAriticleViewModel.articleCellId
    }
    
    func cellHeight() -> CGFloat {
        return 144
        
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: articleCellId, bundle: nil), forCellReuseIdentifier: articleCellId)
    }
}
