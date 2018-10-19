//
//  FTAriticleViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/19/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTAriticleViewModel: BECellDataSource {
    static let feedCellId = "FTAriticleTableViewCell"
    var article: FTFeedInfo
    var imageHeight: CGFloat = (UIScreen.main.bounds.width - 16) * 9 / 16
    var commentHeight: CGFloat = 192.0
    init(a: FTFeedInfo) {
        article = a
    }
    
    func cellIdentifier() -> String {
        return FTFeedViewModel.feedCellId
    }
    
    func cellHeight() -> CGFloat {
        return 180.0 + imageHeight + commentHeight
        
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: feedCellId, bundle: nil), forCellReuseIdentifier: feedCellId)
    }
}
