//
//  FTPhotoPickerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/25/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController

enum PickerType {
    case composer
    case modify
    case article
}

@objc protocol PhotoPickerDelegate {
    func photoPickerDidSelectedAssets(assets: [DKAsset])
    func photoPickerChangeThumbnail(asset: DKAsset?)
}

class FTPhotoPickerViewController: UIViewController {
    weak var delegate: PhotoPickerDelegate?
    var pickerController: DKImagePickerController!
    var assetType: DKImagePickerControllerAssetType = .allPhotos
    var sourceType: DKImagePickerControllerSourceType = .photo
    var navTitle = "Photos"
    var maxSelectableCount = 20
    var coreService: FTCoreService!
    var type: PickerType = .composer
    var content: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let groupDataManagerConfiguration = DKImageGroupDataManagerConfiguration()
        groupDataManagerConfiguration.fetchLimit = 0
        groupDataManagerConfiguration.assetGroupTypes = [.smartAlbumUserLibrary]
        
        let groupDataManager = DKImageGroupDataManager(configuration: groupDataManagerConfiguration)
        
        pickerController = DKImagePickerController(groupDataManager: groupDataManager)
        
        pickerController.inline = true
        pickerController.delegate = self
        pickerController.assetType = assetType
        pickerController.sourceType = sourceType
        pickerController.maxSelectableCount = maxSelectableCount
        pickerController.selectedChanged = {
            print(self.pickerController.selectedAssets.debugDescription)
        }
        let pickerView = pickerController.view!
        pickerView.frame = CGRect(x: 0, y: 90, width: self.view.bounds.width, height: self.view.bounds.height - 90)
        self.view.addSubview(pickerView)
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = UIColor.navigationTitleTextColor()
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString(navTitle, comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(next(_:)))
        nextBarBtn.tintColor = .white
    
        self.navigationItem.rightBarButtonItem = nextBarBtn
    }
    
    init(coreService service: FTCoreService) {
        coreService = service
        super.init(nibName: "FTPhotoPickerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func next(_ sender: Any) {
        switch type {
        case .composer:
            if assetType == .allPhotos {
//                let photoVC = FTPhotoComposerViewController(coreService: coreService, assets: pickerController.selectedAssets)
//                self.navigationController?.pushViewController(photoVC, animated: true)
                self.navigationController?.popViewController(animated: false)
                self.delegate?.photoPickerDidSelectedAssets(assets: pickerController.selectedAssets)
            } else if assetType == .allVideos {
                if let asset = pickerController.selectedAssets.first {
                    //let videoVC = FTVideoComposerViewController(asset: asset)
                    //self.navigationController?.pushViewController(videoVC, animated: true)
                }
            }
        case .modify:
            self.navigationController?.popViewController(animated: false)
            self.delegate?.photoPickerChangeThumbnail(asset: pickerController.selectedAssets.first)
            
        case .article:
            if assetType == .allPhotos {
                let photoVC = FTPhotoComposerViewController(coreService: coreService, assets: pickerController.selectedAssets)
                photoVC.articleContent = content
                photoVC.composerType = .article
                self.navigationController?.pushViewController(photoVC, animated: true)
            }
        }

    }
}

extension FTPhotoPickerViewController: UINavigationControllerDelegate {
    
}
