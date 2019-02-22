//
//  FTPhotoComposerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/25/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DKImagePickerController
import RichEditorView

enum ComposerType: String {
    case photos = "Add Photos"
    case article = "Add Article"
}

enum PrivacyType: Int {
    case `public` = 0
    case `private` = 1
    case follow = 2
}

enum ComposerCellType: Int {
    //[feedCategory, editorVM, switchVM, privacy, checkin, menu, photoVMs]
    case category = 0
    case editor = 1
    case switchVM = 2
    case privacy = 3
    case checkin = 4
    case menu = 5
    case photos = 6
}

struct FTLocationProperties {
    var locationLong: Double = 0
    var locationLat: Double = 0
    var locationName = ""
    var locationThumbnail = ""
    var locationType = ""
    var locationAddress = ""
    var locationDescription = ""
}

enum FTComposerType {
    case photo
    case video
    case blog
    case travel
}

enum FTCategoryType: Int {
    case something = 0
    case travel_checkin = 1
    case food_review = 2
    case review_something = 3
}

//((0, 'Something'), (1, 'Travel Checkin'), (2, 'Food Review'), (3, 'Review something'))`

class FTPhotoComposerViewController: UIViewController {
    
    var composerType: ComposerType = .photos
    var articleContent: String?
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var postText = ""
    var selectedPrivacy:PrivacyType = .public // default is public
    
    //var datasource: [FTPhotoComposerViewModel] = []
    var settings: [BECellDataSource] = []
    var pickerController: DKImagePickerController!
    var backBarBtn: UIBarButtonItem!
    fileprivate let sectionInsets = UIEdgeInsets.zero
    fileprivate let itemsPerRow: CGFloat = 3
    var assets: [DKAsset] = []
    var coreService: FTCoreService!
    var editorVM: FTRichTextViewModel!
    var switchVM: FTSwitchViewModel!
    var addButtonVM: FTPhotoComposerViewModel!
    // location
    var locationProperties: FTLocationProperties?
    var photoVMs: FTPhotosViewModel!
    var selectedComposerType: FTComposerType = .photo
    var feedCategory: FTFeedCategory!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = UIColor.navigationTitleTextColor()
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString(composerType.rawValue, comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(next(_:)))
        nextBarBtn.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = nextBarBtn
        
        generateSettings()
        tableView.dataSource = self
        tableView.delegate = self
        FTFeedCategory.register(tableView: tableView)
        FTRichTextViewModel.register(tableView: tableView)
        FTPhotoSettingViewModel.register(tableView: tableView)
        FTPhotosViewModel.register(tableView: tableView)
        FTSwitchViewModel.register(tableView: tableView)
        tableView.register(FTMenuTableViewCell.self, forCellReuseIdentifier: "FTMenuTableViewCell")
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
        guard assets.count > 0 else { return }
        self.photoVMs.datasource.removeAll()
        for asset in assets {
            asset.fetchOriginalImage { (image, info) in
                print(info?.debugDescription ?? "")
                if let im = image {
                    let vm = FTPhotoComposerViewModel()
                    vm.image = im
                    self.photoVMs.datasource.append(self.addButtonVM)
                    self.settings[self.settings.count - 1 >= 0 ? self.settings.count - 1 : 0] = self.photoVMs
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func initArticleThumbnail() {
        // init default image for thumbnail and remove button
        let vm = FTPhotoComposerViewModel()
        vm.image = UIImage.noImage()
        self.photoVMs.datasource.append(vm)
        self.settings[self.settings.count - 1 >= 0 ? self.settings.count - 1 : 0] = photoVMs
        
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
        for i in 0..<photoVMs.datasource.count - 1 {
            if let image = photoVMs.datasource[i].image {
                imageFiles.append(image)
                // { id: <filename_with_extension_1>, caption: <caption_text1> }
                let name = Date().dateTimeString().appending("\(i).png")
                let caption = "caption_text\(i)"
                let dict = ["id": name, "caption": caption]
                imageDatas.append(dict)
            }
        }
        
//        switch composerType {
//        case .photos:
//            coreService.webService?.composerPhoto(imageFiles: imageFiles, imageDatas: imageDatas, privacy: selectedPrivacy.rawValue, feedText: postText, completion: { (success, response) in
//                NSLog(success ? "SUCCESS" : "FAILED")
//                if !self.postText.isEmpty {
//                    // get new feed, notify to feed screen
//                    NotificationCenter.default.post(name: .ComposerPhotoCompleted, object: nil)
//                }
//            })
//        case .article:
//            break
//        }
        
        switch selectedComposerType {
        case .photo:
            WebService.share.composerPhoto(imageFiles: imageFiles, imageDatas: imageDatas, privacy: selectedPrivacy.rawValue, feedText: postText, category: feedCategory.key, locationProperties: locationProperties) { (success, resposnse) in
                NSLog(success ? "SUCCESS" : "FAILED")
                if !self.postText.isEmpty && success {
                    // get new feed, notify to feed screen
                    NotificationCenter.default.post(name: .ComposerPhotoCompleted, object: nil)
                }
            }
        case .video:
            break
        case .blog:
            break
        case .travel:
            break
        }
    }
    
    func openPhoto() {
        let photoPicker = FTPhotoPickerViewController(coreService: coreService)
        photoPicker.delegate = self
        self.navigationController?.pushViewController(photoPicker, animated: true)
    }
    
    func generateSettings() {
        feedCategory = FTFeedCategory(key: 0, label: "Something", iconName: "explore-app", background: String.somethingBackground(), description: "Something about your life")
        editorVM = FTRichTextViewModel(content: "")
        photoVMs = FTPhotosViewModel()
        addButtonVM = FTPhotoComposerViewModel()
        addButtonVM.image = UIImage(named: "ic_add_new")
        addButtonVM.canDelete = false
        addButtonVM.canEdit = false
        self.photoVMs.datasource = [addButtonVM]
        
        //let postFeed = FTPhotoSettingViewModel(icon: "ic_post_feed", title: NSLocalizedString("Post in NewFeed", comment: ""), markIcon: "")
        
        let privacy = FTPhotoSettingViewModel(icon: "privacy_private", title: NSLocalizedString("Privacy", comment: ""), markIcon: PrivacyIconName.public.rawValue)
        
        let checkin = FTPhotoSettingViewModel(icon: "ic_checkin", title: NSLocalizedString("Check-In", comment: ""), markIcon: "")
        
        let photo = ["title": "Photos", "image": "ic_photo"]
        let video = ["title": "Videos", "image": "ic_video"]
        let blog = ["title": "Blogs", "image": "ic_blog"]
        let travel = ["title": "Travel", "image": "ic_travel"]
        let menu = FTMenuViewModel(arrMenu: [photo, video, blog, travel])
        menu.countRow = 2
        menu.countCol = 3
        
        switchVM = FTSwitchViewModel(imageName: "feed_selected", title: NSLocalizedString("Feed", comment: ""), isOn: true)
        settings = [feedCategory, editorVM, switchVM, privacy, checkin, menu, photoVMs]
    }
    
    fileprivate func reloadCell(type: ComposerCellType) {
        let row = type.rawValue
        let indexPath = IndexPath(row: row, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .none)
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
                    self.photoVMs.datasource.insert(vm, at: self.photoVMs.datasource.count > 1 ? self.photoVMs.datasource.count - 1 : 0)
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
        return photoVMs.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var content: FTPhotoComposerViewModel
        content = photoVMs.datasource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FTPhotoComposerViewModel.cellIdentifier, for: indexPath) as! FTPhotoCollectionViewCell
        cell.delegate = self
        
        // Configure the cell
        cell.renderCell(data: content)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveItem = photoVMs.datasource[sourceIndexPath.row]
        let destinationItem = photoVMs.datasource[destinationIndexPath.row]
        photoVMs.datasource[sourceIndexPath.row] = destinationItem
        photoVMs.datasource[destinationIndexPath.row] = moveItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.row == photoVMs.datasource.count { return false }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == photoVMs.datasource.count {
            openPhoto()
        }
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
        
        if let switchCell = cell as? FTSwitchControlTableViewCell {
            switchCell.delegate = self
        }
        
        
        if let menuCell = cell as? FTMenuTableViewCell {
            menuCell.delegate = self
        }
        
        if let richTextCell = cell as? FTRichTextTableViewCell {
            richTextCell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settings[indexPath.row].cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = ComposerCellType(rawValue: indexPath.row)!
        switch cellType {
        case .category:
            // category
            let categoryVC = FTCategoryPickerViewController()
            categoryVC.delegate = self
            self.navigationController?.pushViewController(categoryVC, animated: true)
        case .editor:
            // post in feed
//            let postVC = FTPostInFeedViewController(postText: postText)
//            postVC.delegate = self
//            self.navigationController?.pushViewController(postVC, animated: true)
            break
        case .switchVM:
            break
        case .privacy:
            // privacy
            let privacyVC = FTPrivacyPickerViewController()
            privacyVC.delegate = self
            self.navigationController?.pushViewController(privacyVC, animated: true)
        case .checkin:
            // check'in
            let checkinVC = FTCheckInViewController()
            checkinVC.delegate = self
            self.navigationController?.pushViewController(checkinVC, animated: true)
        case .menu:
            break
        case .photos:
            break
        }
    }
    
}

extension FTPhotoComposerViewController: PhotoCellDelegate {
    func photoCellDidDelete(_ cell: FTPhotoCollectionViewCell) {
        guard let image = cell.image else { return }
        for vm in photoVMs.datasource {
            guard let icon = vm.image else { continue }
            if icon.isEqual(image) {
                photoVMs.datasource.remove(vm)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
        }
    }
    
    func photoCellDidTapEdit(_ cell: FTPhotoCollectionViewCell) {
        
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
        settings[ComposerCellType.privacy.rawValue] = privacyItem
        reloadCell(type: .privacy)
    }
}

extension FTPhotoComposerViewController: PostInFeedDelegate {
    func postInFeedDidSave(viewController: FTPostInFeedViewController) {
        postText = viewController.getPostText()
        editorVM.content = postText
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

extension FTPhotoComposerViewController: SwitchControlCellDelegate {
    func switchStateDidChange(isOn: Bool) {
        self.editorVM.enable = isOn
        reloadCell(type: .editor)
    }
}

extension FTPhotoComposerViewController: CheckInDelegate {
    func checkInDidSelectedLocation(locationProperties p: FTLocationProperties) {
        self.locationProperties = p
    }
}

extension FTPhotoComposerViewController: FTMenuTableViewCellDelegate {
    func menuTableViewCell(_ menuCell: FTMenuTableViewCell, didSelectedItemAt index: Int) {
        switch index {
        case 0:
            selectedComposerType = .photo
            openPhoto()
        case 1:
            selectedComposerType = .video
        case 2:
            selectedComposerType = .blog
        case 3:
            selectedComposerType = .travel
        default:
            break
        }
    }
}

extension FTPhotoComposerViewController: RichTextCellDelegate {
    func richTextCell(_ editor: RichEditorView, contentDidChange content: String) {
        postText = content
        editorVM.content = content
        settings[ComposerCellType.editor.rawValue] = editorVM
    }
}

extension FTPhotoComposerViewController: CategoryPickerDelegate {
    func didSelectCategory(vc: FTCategoryPickerViewController) {
        feedCategory = vc.selectedCategory
        settings[ComposerCellType.category.rawValue] = feedCategory
        reloadCell(type: .category)
    }
}
