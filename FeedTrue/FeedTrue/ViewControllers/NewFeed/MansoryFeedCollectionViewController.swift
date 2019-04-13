//
//  MansoryFeedCollectionViewController.swift
//  FeedTrue
//
//  Created by Le Cong Toan on 4/10/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "MansoryFeedCollectionViewCell"

class MansoryFeedCollectionViewController: UICollectionViewController {
    
    var dataSource = [FTFeedViewModel]()
    var coreService: FTCoreService!
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init mansory layout
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "MansoryFeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView?.backgroundColor = .white
        collectionView?.dataSource = self
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
       
        // Fetch Data
        self.fetchExploreFeed()
    }
    
    @objc func fetchExploreFeed() {
        _ = self.view
        WebService.share.getFeed(limit: 9, offset: 0, username: nil, ordering: "explore", completion: { [weak self] (success, response) in
            if success {
                NSLog("load feed explore success \(response?.count ?? 0)")
                //                self?.nextURLString = response?.next
                DispatchQueue.main.async {
                    if let feeds = response?.feeds {
                        self?.dataSource.removeAll()
                        self?.dataSource = feeds.map({FTFeedViewModel(f: $0)})
                        self?.collectionView.reloadData()
                    }
                }
            } else {
                NSLog("load feed explore failure")
            }
        })
    }
}

extension MansoryFeedCollectionViewController {
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MansoryFeedCollectionViewCell
        // Configure the cell
        cell.renderCell(data: content)
        return cell
    }
}

extension MansoryFeedCollectionViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let feed = dataSource[indexPath.row]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: feed.ratiosizeFirstThumbnail(), insideRect: boundingRect)
        return rect.size.height
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
//        let photo = dataSource[(indexPath as NSIndexPath).item]
//        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let commentHeight = CGFloat(Int.random(in: 20 ..< 70))
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
    }
}

