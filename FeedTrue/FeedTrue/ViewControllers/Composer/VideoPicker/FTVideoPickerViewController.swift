//
//  FTVideoPickerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/9/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import MobileCoreServices

class FTVideoPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var videoPicker: UIImagePickerController!
    var coreService: FTCoreService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            videoPicker = UIImagePickerController()
            videoPicker.delegate = self
            videoPicker.sourceType = .photoLibrary
            videoPicker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            let pickerView = videoPicker.view!
            pickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.view.addSubview(pickerView)
        }
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = UIColor.navigationTitleTextColor()
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Select Video", comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(next(_:)))
        nextBarBtn.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = nextBarBtn
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func next(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    init(coreService service: FTCoreService) {
        coreService = service
        super.init(nibName: "FTVideoPickerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        dismiss(animated: true, completion: nil)
        NSLog(info.debugDescription)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
