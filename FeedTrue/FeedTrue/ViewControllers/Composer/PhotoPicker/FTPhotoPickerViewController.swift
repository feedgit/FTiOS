//
//  FTPhotoPickerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/25/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController

@objc protocol PhotoPickerDelegate {
    func photoPickerDidSelectedAssets(assets: [DKAsset])
}

class FTPhotoPickerViewController: UIViewController {
    weak var delegate: PhotoPickerDelegate?
    var pickerController: DKImagePickerController!
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
        pickerController.assetType = .allPhotos
        pickerController.sourceType = .photo
        pickerController.maxSelectableCount = 10
        pickerController.selectedChanged = {
            print(self.pickerController.selectedAssets.debugDescription)
        }
        let pickerView = pickerController.view!
        pickerView.frame = CGRect(x: 0, y: 90, width: self.view.bounds.width, height: self.view.bounds.height - 90)
        self.view.addSubview(pickerView)
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Photos", comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(next(_:)))
        nextBarBtn.tintColor = .white
    
        self.navigationItem.rightBarButtonItem = nextBarBtn
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func next(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        //self.delegate?.photoPickerDidSelectedAssets(assets: pickerController.selectedAssets)
        
        let photoVC = FTPhotoComposerViewController(assets: pickerController.selectedAssets)
        self.navigationController?.pushViewController(photoVC, animated: true)
    }
}

extension FTPhotoPickerViewController: UINavigationControllerDelegate {
    
}
