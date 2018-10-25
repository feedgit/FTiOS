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
    var datasource: [FTPhotoComposerViewModel] = []
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
        openPhoto()
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openPhoto() {
        let photoPicker = FTPhotoPickerViewController()
        photoPicker.delegate = self
        //present(photoPicker, animated: true, completion: nil)
        self.navigationController?.pushViewController(photoPicker, animated: true)
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
