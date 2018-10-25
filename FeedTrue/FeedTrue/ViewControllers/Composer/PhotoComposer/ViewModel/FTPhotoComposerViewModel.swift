//
//  FTPhotoComposerViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/25/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTPhotoComposerViewModel: BECollectionCellDataSource {
    static let cellIdentifier = "FTPhotoCollectionViewCell"
    func cellIdemtifier() -> String {
        return FTPhotoComposerViewModel.cellIdentifier
    }
    
    static func register(collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    var datasource: [UIImage] = []
}
