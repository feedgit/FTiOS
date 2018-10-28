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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var datasource: [FTPhotoComposerViewModel] = []
    var settings: [FTPhotoSettingViewModel] = []
    var pickerController: DKImagePickerController!
    var backBarBtn: UIBarButtonItem!
    fileprivate let sectionInsets = UIEdgeInsets.zero
    fileprivate let itemsPerRow: CGFloat = 3
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Add Photos", comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(back(_:)))
        nextBarBtn.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = nextBarBtn
        collectionView.delegate = self
        collectionView.dataSource = self
        FTPhotoComposerViewModel.register(collectionView: collectionView)
        
        generateSettings()
        tableView.dataSource = self
        tableView.delegate = self
        FTPhotoSettingViewModel.register(tableView: tableView)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        openPhoto()
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openPhoto() {
        let photoPicker = FTPhotoPickerViewController()
        photoPicker.delegate = self
        self.navigationController?.pushViewController(photoPicker, animated: true)
    }
    
    func generateSettings() {
        let postFeed = FTPhotoSettingViewModel(icon: "ic_post_feed", title: NSLocalizedString("Post in NewFeed", comment: ""), markIcon: "")
        
        let privacy = FTPhotoSettingViewModel(icon: "privacy_private", title: NSLocalizedString("Privacy", comment: ""), markIcon: "")
        
        let checkin = FTPhotoSettingViewModel(icon: "ic_checkin", title: NSLocalizedString("Check-In", comment: ""), markIcon: "")
        
        settings = [postFeed, privacy, checkin]
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
                        self.collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FTPhotoComposerViewModel.cellIdentifier, for: indexPath) as! FTPhotoCollectionViewCell
        cell.delegate = self
        
        // Configure the cell
        cell.renderCell(data: datasource[indexPath.row])
        return cell
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FTPhotoSettingViewModel.cellID) as! FTPhotoSettingTableViewCell
        cell.renderCell(data: settings[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settings[indexPath.row].cellHeight()
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
                    self.collectionView.reloadData()
                }
                return
            }
        }
    }
}
