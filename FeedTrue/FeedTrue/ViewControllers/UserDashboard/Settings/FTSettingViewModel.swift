//
//  FTSettingViewModel.swift
//  FeedTrue
//
//  Created by Le Cong Toan on 1/21/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTSettingViewModel: BECellDataSource {
    static let cellID = "FTMenuItemTableViewCell"
    var imageName: String
    var title: String
    init(imageName im: String, title t: String) {
        imageName = im
        title = t
    }
    
    func cellIdentifier() -> String {
        return FTSettingViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 50
        
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
}
