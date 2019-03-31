//
//  FTThumnailInfoVC.swift
//  FeedTrue
//
//  Created by Quoc Le on 3/30/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import DKImagePickerController

class FTThumnailInfoVC: UIViewController {
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var videoURL: URL
    var thumbnail: UIImage?
    
    init(videoURL url: URL) {
        videoURL = url
        super.init(nibName: "FTThumnailInfoVC", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let addTap = UITapGestureRecognizer(target: self, action: #selector(addThumbnail(_:)))
        self.addImageView.isUserInteractionEnabled = true
        self.addImageView.addGestureRecognizer(addTap)
        
        let thumbnailTap = UITapGestureRecognizer(target: self, action: #selector(addThumbnail(_:)))
        self.thumbnailImageView.isUserInteractionEnabled = true
        self.thumbnailImageView.addGestureRecognizer(thumbnailTap)
        
        let list: [UIImageView] = [addImageView, thumbnailImageView]
        for item in list {
            item.layer.borderColor = UIColor.gray.cgColor
            item.layer.borderWidth = 1
            item.clipsToBounds = true
            item.cornerRadius = 5
        }
        
        thumbnail = thumbnail(sourceURL: videoURL)
        thumbnailImageView.image = thumbnail
    }
    
    @objc func addThumbnail(_ sender: UIImageView) {
        let photoPicker = FTPhotoPickerViewController(coreService: FTCoreService.share)
        photoPicker.delegate = self
        photoPicker.type = .modify
        photoPicker.maxSelectableCount = 1
        if let topVC = UIApplication.topViewController() {
            topVC.navigationController?.pushViewController(photoPicker, animated: true)
        }
        
    }

    func thumbnail(sourceURL:URL) -> UIImage? {
        let asset = AVAsset(url: sourceURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 1)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print(error)
            return nil
        }
    }

}

extension FTThumnailInfoVC: PhotoPickerDelegate {
    func photoPickerChangeThumbnail(asset: DKAsset?) {
        asset?.fetchOriginalImage(completeBlock: { (image, info) in
            DispatchQueue.main.async {
                self.thumbnail = image
                self.thumbnailImageView.image = image
            }
        })
    }
    
    func photoPickerDidSelectedAssets(assets: [DKAsset]) {
        guard let asset = assets.first else { return }
        asset.fetchOriginalImage { (image, info) in
            print(info?.debugDescription ?? "")
            DispatchQueue.main.async {
                self.thumbnail = image
                self.thumbnailImageView.image = image
            }
        }
    }
}
