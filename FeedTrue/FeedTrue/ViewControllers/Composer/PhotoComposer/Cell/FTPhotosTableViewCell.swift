//
//  FTPhotosTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/6/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController
import PixelEditor
import PixelEngine
import Gallery

class FTPhotosTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTPhotosViewModel
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    //var datasource: [FTPhotoComposerViewModel] = []
    fileprivate let sectionInsets = UIEdgeInsets.zero
    fileprivate let itemsPerRow: CGFloat = 3
    var contentData: FTPhotosViewModel!
    fileprivate var editIndex: IndexPath = IndexPath(row: 0, section: 0)
    var gallery: GalleryController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Gallery.Config.VideoEditor.savesEditedVideoToLibrary = true
        collectionView.delegate = self
        collectionView.dataSource = self
        FTPhotoComposerViewModel.register(collectionView: collectionView)
        collectionView.dragInteractionEnabled = true
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    func renderCell(data: FTPhotosViewModel) {
        contentData = data
        //datasource = data.datasource
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed: collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
}

extension FTPhotosTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentData.datasource.count + 1// > 1 ? contentData.datasource.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == contentData.datasource.count {
            let addButtonVM = FTPhotoComposerViewModel()
            addButtonVM.image = UIImage(named: "ic_add_new")
            addButtonVM.canDelete = false
            addButtonVM.canEdit = false
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FTPhotoComposerViewModel.cellIdentifier, for: indexPath) as! FTPhotoCollectionViewCell
            cell.delegate = self
            
            // Configure the cell
            cell.tag = indexPath.row
            cell.renderCell(data: addButtonVM)
            cell.deleteImageView.isHidden = !addButtonVM.canDelete
            return cell
        }
        let content = contentData.datasource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FTPhotoComposerViewModel.cellIdentifier, for: indexPath) as! FTPhotoCollectionViewCell
        cell.delegate = self
        
        // Configure the cell
        cell.tag = indexPath.row
        cell.renderCell(data: content)
        cell.deleteImageView.isHidden = !content.canDelete
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
//        let content = datasource[indexPath.row]
//        if let image = content.image {
//            let controller = PixelEditViewController(image: image, doneButtonTitle: "Done", colorCubeStorage: .default, options: .current)
//            controller.delegate = self
//            if let topVC = UIApplication.topViewController() {
//                topVC.navigationController?.pushViewController(controller, animated: true)
//                editIndex = indexPath
//            }
//        }
        if indexPath.row == contentData.datasource.count {
//            let photoPicker = FTPhotoPickerViewController(coreService: FTCoreService.share)
//            photoPicker.delegate = self
            self.gallery = GalleryController()
            self.gallery.delegate = self
            if let topVC = UIApplication.topViewController() {
                 topVC.present(self.gallery, animated: true, completion: nil)
            }
           
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveItem = contentData.datasource[sourceIndexPath.row]
        let destinationItem = contentData.datasource[destinationIndexPath.row]
        contentData.datasource[sourceIndexPath.row] = destinationItem
        contentData.datasource[destinationIndexPath.row] = moveItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.row == contentData.datasource.count { return false }
        return true
    }
}

extension FTPhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = frame.width
        let widthPerItem = availableWidth / itemsPerRow - 8
        
        return CGSize(width: widthPerItem, height: widthPerItem + 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

extension FTPhotosTableViewCell: PhotoCellDelegate {
    func photoCellDidDelete(_ cell: FTPhotoCollectionViewCell) {
        guard let image = cell.image else { return }
        for vm in contentData.datasource {
            guard let icon = vm.image else { continue }
            if icon.isEqual(image) {
                contentData.datasource.remove(vm)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                return
            }
        }
    }
    
    func photoCellDidTapEdit(_ cell: FTPhotoCollectionViewCell) {
        if let image = cell.imageViewIcon.image {
            let controller = PixelEditViewController(image: image, doneButtonTitle: "Done", colorCubeStorage: .default, options: .current)
            controller.delegate = self
            if let topVC = UIApplication.topViewController() {
                topVC.navigationController?.pushViewController(controller, animated: true)
                //editIndex = indexPath
                if cell.tag < contentData.datasource.count {
                    let indexPath = IndexPath(row: cell.tag, section: 0)
                    editIndex = indexPath
                }
            }
        }
    }
}

extension FTPhotosTableViewCell: PixelEditViewControllerDelegate {
    func pixelEditViewController(_ controller: PixelEditViewController, didEndEditing editingStack: SquareEditingStack) {
        if let topVC = UIApplication.topViewController() {
            topVC.navigationController?.popViewController(animated: true)
        }
        let image = editingStack.makeRenderer().render(resolution: .full)
        let vm = contentData.datasource[editIndex.row]
        vm.image = image
        contentData.datasource[editIndex.row] = vm
        collectionView.reloadItems(at: [editIndex])
    }
    
    func pixelEditViewControllerDidCancelEditing(in controller: PixelEditViewController) {
        if let topVC = UIApplication.topViewController() {
            topVC.navigationController?.popViewController(animated: true)
        }
    }
    

}

extension FTPhotosTableViewCell: PhotoPickerDelegate {
    func photoPickerDidSelectedAssets(assets: [DKAsset]) {
        for asset in assets {
            asset.fetchOriginalImage { (image, info) in
                print(info?.debugDescription ?? "")
                if let im = image {
                    let vm = FTPhotoComposerViewModel()
                    vm.image = im
                    // insert in front of add button
                    self.contentData.datasource.insert(vm, at: self.contentData.datasource.count > 1 ? self.contentData.datasource.count - 1 : 0)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func photoPickerChangeThumbnail(asset: DKAsset?) {
        
    }
    
}


extension FTPhotosTableViewCell: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Gallery.Image]) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
        
        for item in images {
            item.resolve { (image) in
                let vm = FTPhotoComposerViewModel()
                vm.image = image
                // insert in front of add button
                self.contentData.datasource.insert(vm, at: self.contentData.datasource.count > 1 ? self.contentData.datasource.count - 1 : 0)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    
}
