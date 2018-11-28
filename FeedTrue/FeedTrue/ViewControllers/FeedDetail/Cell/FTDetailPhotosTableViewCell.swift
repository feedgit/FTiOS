//
//  FTDetailPhotosTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/28/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTDetailPhotosTableViewCell: UITableViewCell, BECellRenderImpl, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var content: FTDetailPhotosViewModel?
    var photos: [Photo]!
    
    typealias CellData = FTDetailPhotosViewModel
    let collectionViewWidth = UIScreen.main.bounds.width
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.Identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero//UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(data: FTDetailPhotosViewModel) {
        content = data
        photos = content?.photos ?? []
    }
    
}


extension FTDetailPhotosTableViewCell {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.Identifier, for: indexPath) as! PhotoCell
        cell.photo = self.photos[indexPath.row]
        let type = cell.photo?.type ?? .image
        switch type {
        case .image:
            if let url = URL(string: cell.photo?.url ?? "") {
                cell.imageView.loadImage(fromURL: url, defaultImage: UIImage.noImage())
                let skphoto = SKPhoto(url: cell.photo!.url!)
                skphoto.loadUnderlyingImageComplete()
            } else {
                cell.imageView.image = UIImage.noImage()
            }
        case .video:
            if let url = URL(string: cell.photo?.thumbnailURL ?? "") {
                cell.imageView.loadImage(fromURL: url, defaultImage: UIImage.noImage())
            } else {
                cell.imageView.image = UIImage.noImage()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
//        let originImage = cell.imageView.image // some image for baseImage
//
//        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: skPhotos, animatedFromView: cell)
//        browser.initializePageIndex(indexPath.row)
//        if let topVC = UIApplication.topViewController() {
//            topVC.present(browser, animated: false, completion: nil)
//        }
    }
}

extension FTDetailPhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if photos.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        if photos.count == 1 {
            let photo = photos[indexPath.row]
            if let width = photo.width, let height = photo.height, photo.type == .image {
                NSLog("\(#function) width: \(width), height: \(height)")
                var h: CGFloat = collectionViewWidth / 2.0
                var w: CGFloat = 2 * collectionViewWidth / 3.0
                NSLog("width: \(width), height: \(height)")
                if width > height {
                    // limit width = screen width / 2
                    h = CGFloat(height) * (2.0 * collectionViewWidth / 3.0) / CGFloat(width)
                } else if width < height {
                    // limit height = 2/3 screen width
                    h = collectionViewWidth
                    w = CGFloat(width) * h / CGFloat(height)
                } else {
                    // width = height
                    h = 2 * collectionViewWidth / 3.0
                    w = h
                }
                NSLog("\(#function) size_w: \(w), size_h: \(h)")
                return CGSize(width: w, height: h)
            } else {
                // video
                let h = collectionViewWidth * 2.0 / 3.0
                return CGSize(width: collectionViewWidth, height: h)
            }
            //return CGSize(width: collectionViewWidth / 2, height: collectionViewWidth / 2)
        }
        // 2+ photos
        let h = collectionViewWidth / 3.0
        return CGSize(width: h - 1, height: h - 1)
    }
    
}
