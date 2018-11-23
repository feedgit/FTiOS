//
//  FTPhotoComposerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/25/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController

enum ComposerType: String {
    case photos = "Add Photos"
    case article = "Add Article"
}

enum PrivacyType: Int {
    case `public` = 0
    case `private` = 1
    case follow = 2
}

class FTPhotoComposerViewController: UIViewController {
    
    var composerType: ComposerType = .photos
    var articleContent: String?
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var postText = ""
    var selectedPrivacy:PrivacyType = .public // default is public
    
    var datasource: [FTPhotoComposerViewModel] = []
    var settings: [BECellDataSource] = []
    var pickerController: DKImagePickerController!
    var backBarBtn: UIBarButtonItem!
    fileprivate let sectionInsets = UIEdgeInsets.zero
    fileprivate let itemsPerRow: CGFloat = 3
    var assets: [DKAsset] = []
    var coreService: FTCoreService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString(composerType.rawValue, comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(next(_:)))
        nextBarBtn.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = nextBarBtn
        
        generateSettings()
        tableView.dataSource = self
        tableView.delegate = self
        FTPhotoSettingViewModel.register(tableView: tableView)
        FTPhotosViewModel.register(tableView: tableView)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        loadAssets()
    }
    
    init(coreService service: FTCoreService, assets a: [DKAsset]) {
        self.coreService = service
        self.assets = a
        super.init(nibName: "FTPhotoComposerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAssets() {
        for asset in assets {
            asset.fetchOriginalImage { (image, info) in
                print(info?.debugDescription ?? "")
                if let im = image {
                    let vm = FTPhotoComposerViewModel()
                    vm.image = im
                    self.datasource.append(vm)
                    let photos = FTPhotosViewModel()
                    photos.datasource = self.datasource
                    self.settings[0] = photos
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }

    }
    
    func initArticleThumbnail() {
        // init default image for thumbnail and remove button
        let vm = FTPhotoComposerViewModel()
        vm.image = UIImage.noImage()
        self.datasource.append(vm)
        let photos = FTPhotosViewModel()
        photos.datasource = self.datasource
        self.settings[0] = photos
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func next(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
        var imageFiles: [UIImage] = []
        var imageDatas: [[String: String]] = []
        for i in 0..<datasource.count {
            if let image = datasource[i].image {
                imageFiles.append(image)
                // { id: <filename_with_extension_1>, caption: <caption_text1> }
                let name = Date().dateTimeString().appending("\(i).png")
                let caption = "caption_text\(i)"
                let dict = ["id": name, "caption": caption]
                imageDatas.append(dict)
            }
        }
        
        switch composerType {
        case .photos:
            coreService.webService?.composerPhoto(imageFiles: imageFiles, imageDatas: imageDatas, privacy: selectedPrivacy.rawValue, feedText: postText, completion: { (success, response) in
                NSLog(success ? "SUCCESS" : "FAILED")
                if !self.postText.isEmpty {
                    // get new feed, notify to feed screen
                    NotificationCenter.default.post(name: .ComposerPhotoCompleted, object: nil)
                }
            })
        case .article:
            break
        }
    }
    
    func openPhoto() {
        let photoPicker = FTPhotoPickerViewController(coreService: coreService)
        photoPicker.delegate = self
        self.navigationController?.pushViewController(photoPicker, animated: true)
    }
    
    func generateSettings() {
        let photos = FTPhotosViewModel()
        photos.datasource = self.datasource
        
        let postFeed = FTPhotoSettingViewModel(icon: "ic_post_feed", title: NSLocalizedString("Post in NewFeed", comment: ""), markIcon: "")
        
        let privacy = FTPhotoSettingViewModel(icon: "privacy_private", title: NSLocalizedString("Privacy", comment: ""), markIcon: PrivacyIconName.public.rawValue)
        
        let checkin = FTPhotoSettingViewModel(icon: "ic_checkin", title: NSLocalizedString("Check-In", comment: ""), markIcon: "")
        
        settings = [photos, postFeed, privacy, checkin]
    }
}

extension FTPhotoComposerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

extension FTPhotoComposerViewController: PhotoPickerDelegate {
    func photoPickerChangeThumbnail(asset: DKAsset?) {
    }
    
    func photoPickerDidSelectedAssets(assets: [DKAsset]) {
        for asset in assets {
            asset.fetchOriginalImage { (image, info) in
                print(info?.debugDescription ?? "")
                if let im = image {
                    let vm = FTPhotoComposerViewModel()
                    vm.image = im
                    self.datasource.append(vm)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension FTPhotoComposerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = datasource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FTPhotoComposerViewModel.cellIdentifier, for: indexPath) as! FTPhotoCollectionViewCell
        cell.delegate = self
        
        // Configure the cell
        cell.renderCell(data: content)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveItem = datasource[sourceIndexPath.row]
        let destinationItem = datasource[destinationIndexPath.row]
        datasource[sourceIndexPath.row] = destinationItem
        datasource[destinationIndexPath.row] = moveItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.row == datasource.count { return false }
        return true
    }
}

extension FTPhotoComposerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth / itemsPerRow - 8
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

extension FTPhotoComposerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        if let renderCell = cell as? BECellRender {
            renderCell.renderCell(data: content)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settings[indexPath.row].cellHeight()
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

extension FTPhotoComposerViewController: PhotoCellDelegate {
    func photoCellDidDelete(_ cell: FTPhotoCollectionViewCell) {
        guard let image = cell.image else { return }
        for vm in datasource {
            guard let icon = vm.image else { continue }
            if icon.isEqual(image) {
                datasource.remove(vm)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
        }
    }
}

extension FTPhotoComposerViewController: PrivacyPickerDelegate {
    func privacyDidSave(vc: FTPrivacyPickerViewController) {
        guard let privacy = vc.selectedPrivacy else { return }
        let iconName = PrivacyIconName(rawValue: privacy.imageName)!
        switch iconName {
        case .public:
            selectedPrivacy = .public
        case .private:
            selectedPrivacy = .private
        case .follow:
            selectedPrivacy = .follow
        }
        
        let privacyItem = FTPhotoSettingViewModel(icon: "privacy_private", title: NSLocalizedString("Privacy", comment: ""), markIcon: privacy.imageName)
        settings[2] = privacyItem
        let indexPath = IndexPath(row: 2, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension FTPhotoComposerViewController: PostInFeedDelegate {
    func postInFeedDidSave(viewController: FTPostInFeedViewController) {
        postText = viewController.getPostText()
        var markIcontName = ""
        if postText != "" {
            markIcontName = "ic_tick"
        }
        
        let postFeed = FTPhotoSettingViewModel(icon: "ic_post_feed", title: NSLocalizedString("Post in NewFeed", comment: ""), markIcon: markIcontName)
        settings[1] = postFeed
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
