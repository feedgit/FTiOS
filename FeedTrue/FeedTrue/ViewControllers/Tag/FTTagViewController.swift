//
//  FTTagViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FTTagViewCell"

@objc protocol VideoControllerDelegate {
//    func videoGoHome()
}

class FTTagViewController: UICollectionViewController {
    weak var delegate: VideoControllerDelegate?
    var datasource: [TagExploreContent] = []
    var coreService: FTCoreService!
    var nextURLString: String?
    fileprivate let sectionInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate var backBarBtn: UIBarButtonItem!
    var refreshControl: UIRefreshControl?
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView?.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        // Do any additional setup after loading the view.
        self.fetchTags()
        setUpRefreshControl()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.collectionView?.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.rightBarButtonItem = nil
        
        let leftTitle = UIBarButtonItem(title: NSLocalizedString("Tags", comment: ""), style: .plain, target: self, action: nil)
        self.parent?.navigationItem.leftBarButtonItem = leftTitle
        
        self.parent?.navigationItem.title = nil
    }
    
//    @objc func back(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//        self.delegate?.videoGoHome()
//    }
    
    init(coreService c: FTCoreService) {
        coreService = c
        super.init(nibName: "FTTagViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        //refreshControl?.tintColor = UIColor.blue
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        collectionView?.addSubview(refreshControl!)
    }
    
    @objc func refreshControlValueChanged(_ sender: UIRefreshControl) {
        self.refreshControl?.endRefreshing()
        self.fetchTags()
    }
    
    @objc func fetchTags() {
        _ = self.view
        coreService.webService?.fetchTagExplore(completion: { [weak self] (success, response) in
            if success {
                NSLog("load tag success \(response?.count ?? 0)")
                self?.nextURLString = response?.next
                DispatchQueue.main.async {
                    if let tags = response?.results {
                        self?.datasource.removeAll()
                        self?.datasource = tags
                        self?.collectionView?.reloadData()
//                        self?.tableView.addBotomActivityView {
//                            self?.loadMore()
//                        }
                    }
                    
                }
            } else {
                NSLog("load tag failure")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FTTagViewCell
    
        // Configure the cell
        cell.render(content: datasource[indexPath.row])
        return cell
    }

}

extension FTTagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        // Size of Tag Cell (W, H: Width, Width * 1.5)
        return CGSize(width: widthPerItem, height: widthPerItem*1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
