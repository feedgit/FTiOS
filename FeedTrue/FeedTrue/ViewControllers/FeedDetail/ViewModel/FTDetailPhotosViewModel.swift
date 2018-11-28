//
//  FTDetailPhotosViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/28/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTDetailPhotosViewModel: BECellDataSource {
    static let cellID = "FTDetailPhotosTableViewCell"
    var photos = [Photo]()
    
    init(photos p: [Photo]) {
        photos = p
    }
    
    func cellIdentifier() -> String {
        return FTDetailPhotosViewModel.cellID
    }
    
    func cellHeight() -> CGFloat {
        let collectionViewWidth = UIScreen.main.bounds.width - 16
        if photos.count == 1 {
            var h: CGFloat = collectionViewWidth * (2.0/3.0)
            guard let photo = photos.first else { return 0 }
            if let width = photo.width, let height = photo.height {
                NSLog("width: \(width), height: \(height)")
                if width > height {
                    // limit width = screen width / 2
                    h = CGFloat(height) * (2.0 * collectionViewWidth / 3.0) / CGFloat(width)
                } else if width < height {
                    // limit height = 2/3 screen width
                    h = collectionViewWidth
                } else {
                    // width = height
                    h = 2 * collectionViewWidth / 3.0
                }
            }
            return h
        } else if photos.count > 1 {
            return (collectionViewWidth / 3) * CGFloat(ceilf(Float(photos.count) / 3.0))
            
        }
        return 0
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
}
