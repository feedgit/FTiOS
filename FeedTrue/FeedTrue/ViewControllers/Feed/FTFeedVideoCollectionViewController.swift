//
//  FTFeedVideoCollectionViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FTFeedVideoCollectionViewCell"

class FTFeedVideoCollectionViewController: UICollectionViewController {
    var datasource: [FTFeedVideoContent] = []
    var coreService: FTCoreService!
    var nextURLString: String?
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(FTFeedVideoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        // Do any additional setup after loading the view.
        self.collectionView?.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.loadFeed()
    }
    
    init(coreService c: FTCoreService) {
        coreService = c
        super.init(nibName: "FTFeedVideoCollectionViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func loadFeed() {
        _ = self.view
        guard let token = coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        coreService.webService?.getFeedVideo(username: nil, token: token, completion: { [weak self] (success, response) in
            if success {
                NSLog("load feed success \(response?.count ?? 0)")
                self?.nextURLString = response?.next
                DispatchQueue.main.async {
                    if let feeds = response?.results {
                        self?.datasource.removeAll()
                        self?.datasource = feeds
                        self?.collectionView?.reloadData()
//                        self?.tableView.addBotomActivityView {
//                            self?.loadMore()
//                        }
                    }
                    
                }
            } else {
                NSLog("load feed failure")
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FTFeedVideoCollectionViewCell
    
        // Configure the cell
        cell.render(content: datasource[indexPath.row])
        cell.delegate = self
        return cell
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}

extension FTFeedVideoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension FTFeedVideoCollectionViewController: VideoCellDelegate {
    func videoCellDidRemoveReaction(cell: FTFeedVideoCollectionViewCell) {
        guard let token = coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        
        guard let ct_id = cell.contetnData?.id else { return }
        guard let ct_name = cell.contetnData?.ct_name else { return }
        coreService.webService?.removeReact(token: token, ct_name: ct_name, ct_id: ct_id, completion: { (success, msg) in
            if success {
                NSLog("Remove react successful")
            } else {
                NSLog("Remove react failed")
                DispatchQueue.main.async {
                    guard let indexPath = self.collectionView?.indexPath(for: cell) else { return }
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        })
    }
    
    func videoCellDidChangeReactionType(cell: FTFeedVideoCollectionViewCell) {
        guard let token = coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        
        guard let ct_id = cell.contetnData?.id else { return }
        guard let ct_name = cell.contetnData?.ct_name else { return }
        let react_type = cell.ftReactionType.rawValue
        coreService.webService?.react(token: token, ct_name: ct_name, ct_id: ct_id, react_type: react_type, completion: { (success, type) in
            if success {
                NSLog("did react successful \(type ?? "")")
            } else {
                NSLog("did react failed \(react_type)")
                DispatchQueue.main.async {
                    guard let indexPath = self.collectionView?.indexPath(for: cell) else { return }
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        })
    }
}
