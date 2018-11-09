//
//  FTVideoComposerViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTVideoComposerViewModel: BECellDataSource {
    static let cellIdentifier = "FTVideoComposerTableViewCell"
    func cellIdentifier() -> String {
        return FTVideoComposerViewModel.cellIdentifier
    }
    
    func cellHeight() -> CGFloat {
        return 512
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    var image: UIImage?
    var thumbnail: UIImage?
    var title = ""
    var description = ""
}
