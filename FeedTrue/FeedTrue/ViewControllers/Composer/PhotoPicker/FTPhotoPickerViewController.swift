//
//  FTPhotoPickerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/25/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController

class FTPhotoPickerViewController: UIViewController {
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
        //pickerController.UIDelegate = CustomInlineLayoutUIDelegate(imagePickerController: pickerController)
        pickerController
        pickerController.assetType = .allPhotos
        pickerController.sourceType = .photo
        pickerController.maxSelectableCount = 10
        let pickerView = pickerController.view!
        pickerView.frame = CGRect(x: 0, y: 88, width: self.view.bounds.width, height: self.view.bounds.height - 88)
        self.view.addSubview(pickerView)
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Photos", comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(back(_:)))
        nextBarBtn.tintColor = .white
    
        self.navigationItem.rightBarButtonItem = nextBarBtn
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
