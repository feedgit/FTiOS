//
//  ArticelThumbnailViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/9/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class ArticelThumbnailViewModel: BECellDataSource {
    static let cellID = "ArticleThumbnailTableViewCell"
    
    var thumbnailURL: String
    
    init(thumbnai url: String) {
        thumbnailURL = url
    }
    
    func cellIdentifier() -> String {
        return ArticelThumbnailViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return UIScreen.main.bounds.width * 9.0 / 16.0
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    

}
