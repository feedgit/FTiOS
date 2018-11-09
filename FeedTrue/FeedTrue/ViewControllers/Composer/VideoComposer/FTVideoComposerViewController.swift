//
//  FTVideoComposerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController

class FTVideoComposerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [BECellDataSource] = []
    var asset: DKAsset?
    var postText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Add Video", comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(next(_:)))
        nextBarBtn.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = nextBarBtn
        generateDataSource()
        loadAsset()
        tableView.dataSource = self
        tableView.delegate = self
        FTPhotoSettingViewModel.register(tableView: tableView)
        FTVideoComposerViewModel.register(tableView: tableView)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func next(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    init(asset a: DKAsset) {
        asset = a
        super.init(nibName: "FTVideoComposerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateDataSource() {
        let video = FTVideoComposerViewModel()
        let postFeed = FTPhotoSettingViewModel(icon: "ic_post_feed", title: NSLocalizedString("Post in NewFeed", comment: ""), markIcon: "")
        
        let privacy = FTPhotoSettingViewModel(icon: "privacy_private", title: NSLocalizedString("Privacy", comment: ""), markIcon: PrivacyIconName.public.rawValue)
        
        let checkin = FTPhotoSettingViewModel(icon: "ic_checkin", title: NSLocalizedString("Check-In", comment: ""), markIcon: "")
        
        dataSource = [video, postFeed, privacy, checkin]
    }
    
    func loadAsset() {
        asset?.fetchOriginalImage { (image, info) in
            print(info?.debugDescription ?? "")
                if let videoVM = self.dataSource.first as? FTVideoComposerViewModel {
                    videoVM.image = image
                    videoVM.thumbnail = image
                    self.dataSource[0] = videoVM
                }
            
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
    }

}

extension FTVideoComposerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        if let renderCell = cell as? BECellRender {
            renderCell.renderCell(data: content)
        }
        
        if let videoCell = cell as? FTVideoComposerTableViewCell {
            videoCell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = dataSource[indexPath.row]
        return content.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            // post in feed
            let postVC = FTPostInFeedViewController(postText: postText)
            postVC.delegate = self
            self.navigationController?.pushViewController(postVC, animated: true)
        } else if indexPath.row == 2 {
            // privacy
            let privacyVC = FTPrivacyPickerViewController()
            privacyVC.delegate = self
            self.navigationController?.pushViewController(privacyVC, animated: true)
        }
    }
}

extension FTVideoComposerViewController: PrivacyPickerDelegate {
    func privacyDidSave(vc: FTPrivacyPickerViewController) {
        guard let privacy = vc.selectedPrivacy else { return }
        let privacyItem = FTPhotoSettingViewModel(icon: "privacy_private", title: NSLocalizedString("Privacy", comment: ""), markIcon: privacy.imageName)
        dataSource[2] = privacyItem
        tableView.reloadData()
    }
}

extension FTVideoComposerViewController: PostInFeedDelegate {
    func postInFeedDidSave(viewController: FTPostInFeedViewController) {
        postText = viewController.getPostText()
        var markIcontName = ""
        if postText != "" {
            markIcontName = "ic_tick"
        }
        
        let postFeed = FTPhotoSettingViewModel(icon: "ic_post_feed", title: NSLocalizedString("Post in NewFeed", comment: ""), markIcon: markIcontName)
        dataSource[1] = postFeed
        tableView.reloadData()
    }
}

extension FTVideoComposerViewController: PhotoPickerDelegate {
    func photoPickerChangeThumbnail(asset: DKAsset?) {
        asset?.fetchOriginalImage(completeBlock: { (image, info) in
            if let content = self.dataSource[0] as? FTVideoComposerViewModel {
                content.thumbnail = image
                self.dataSource[0] = content
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
            }
        })
    }
    
    func photoPickerDidSelectedAssets(assets: [DKAsset]) {
        guard let asset = assets.first else { return }
        asset.fetchOriginalImage { (image, info) in
            print(info?.debugDescription ?? "")
            if let content = self.dataSource[0] as? FTVideoComposerViewModel {
                content.thumbnail = image
                self.dataSource[0] = content
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
            }
        }
    }
}


extension FTVideoComposerViewController: VideoComposerCellDelegate {
    func thumbnailTouchUpAction(cell: FTVideoComposerTableViewCell) {
        let photoPicker = FTPhotoPickerViewController(coreService: FTCoreService())
        photoPicker.delegate = self
        photoPicker.type = .modify
        photoPicker.maxSelectableCount = 1
        self.navigationController?.pushViewController(photoPicker, animated: true)
    }
}
