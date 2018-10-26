//
//  FTPhotoSettingViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/26/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTPhotoSettingViewModel: BECellDataSource {
    static let cellID = "FTPhotoSettingTableViewCell"
    func cellIdentifier() -> String {
        return FTPhotoSettingViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 64
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    var icon: String?
    var title: String?
    var markIcon: String?
    init(icon ic: String, title t: String, markIcon m_ic: String) {
        icon = ic
        title = t
        markIcon = m_ic
    }
    

}
