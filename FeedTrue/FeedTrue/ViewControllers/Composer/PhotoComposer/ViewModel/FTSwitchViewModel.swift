//
//  FTSwitchViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/31/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTSwitchViewModel: BECellDataSource {
    static let cellID = "FTSwitchControlTableViewCell"
    func cellIdentifier() -> String {
        return FTSwitchViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 64
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    var imageName: String
    var title: String
    var isOn: Bool
    
    init(imageName im: String, title t: String, isOn on: Bool) {
        imageName = im
        title = t
        isOn = on
    }

}
