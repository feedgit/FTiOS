//
//  FTPrivacyViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/29/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTPrivacyViewModel: BECellDataSource {
    static let cellID = "FTPrivacyPickerTableViewCell"
    func cellIdentifier() -> String {
        return FTPrivacyViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        return 64
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    var privacy: FTPrivacy!
    
    init(privace p: FTPrivacy) {
        privacy = p
    }
    
}

struct FTPrivacy {
    var title: String
    var detail: String
    var imageName: String
    
    init(title t: String, detail d: String, imageName name: String) {
        title = t
        detail = d
        imageName = name
    }
}
