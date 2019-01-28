//
//  FTPhotosViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/6/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController

class FTPhotosViewModel: BECellDataSource {
    static let cellID = "FTPhotosTableViewCell"
    func cellIdentifier() -> String {
        return FTPhotosViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        if datasource.count > 0 && datasource.count < 3 {
            return UIScreen.main.bounds.width / 3 + 64
        } else {
            return (UIScreen.main.bounds.width / 3 + 64) * CGFloat((self.datasource.count / 3 + (self.datasource.count % 3 != 0 ? 1 : 0)))
        }
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    var datasource: [FTPhotoComposerViewModel] = []
}
