//
//  FTPhotosTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/6/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController

class FTPhotosTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTPhotosViewModel
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var datasource: [FTPhotoComposerViewModel] = []
    fileprivate let sectionInsets = UIEdgeInsets.zero
    fileprivate let itemsPerRow: CGFloat = 3
    var contentData: FTPhotosViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        FTPhotoComposerViewModel.register(collectionView: collectionView)
        collectionView.dragInteractionEnabled = true
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    func renderCell(data: FTPhotosViewModel) {
        contentData = data
        datasource = data.datasource
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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

extension FTPhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = frame.width
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

extension FTPhotosTableViewCell: PhotoCellDelegate {
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