//
//  FTPhotoComposerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/25/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController

class FTPhotoComposerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var postText = ""
    
    var datasource: [FTPhotoComposerViewModel] = []
    var settings: [BECellDataSource] = []
    var pickerController: DKImagePickerController!
    var backBarBtn: UIBarButtonItem!
    fileprivate let sectionInsets = UIEdgeInsets.zero
    fileprivate let itemsPerRow: CGFloat = 3
    var assets: [DKAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Add Photos", comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(next(_:)))
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
    
    init(assets a: [DKAsset]) {
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
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func next(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func openPhoto() {
        let photoPicker = FTPhotoPickerViewController()
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
