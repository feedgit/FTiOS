//
//  FTFeedTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/13/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import SwiftMoment

@objc protocol FTFeedCellDelegate {
    func feeddCellGotoFeed(cell: FTFeedTableViewCell)
    func feeddCellShare(cell: FTFeedTableViewCell)
    func feeddCellSeeLessContent(cell: FTFeedTableViewCell)
    func feeddCellReportInapproriate(cell: FTFeedTableViewCell)
    func feeddCellEdit(cell: FTFeedTableViewCell)
    @objc func feeddCellPermanentlyDelete(cell: FTFeedTableViewCell)
    func feedCellDidTapUsername(username: String)
    func feedCellDidChangeReactionType(cell: FTFeedTableViewCell)
    func feedCellDidRemoveReaction(cell: FTFeedTableViewCell)
    func feedCellDidSave(cell: FTFeedTableViewCell)
    func feedCellDidUnSave(cell: FTFeedTableViewCell)
    func feedCellDidTouchUpComment(cell: FTFeedTableViewCell)
    func feedCellShowDetail(cell: FTFeedTableViewCell)
    func feedCellNeedReload(cell: FTFeedTableViewCell)
}

public enum FTReactionTypes: String {
    case love = "LOVE"
    case laugh = "LAUGH"
    case wow = "WOW"
    case sad = "SAD"
    case angry = "ANGRY"
}

public enum FTPrivacyType: String {
    case `public` = "privacy_public"
    case follow = "privacy_follow"
    case secret = "privacy_private"
}

class FTFeedTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTFeedViewModel
    weak var delegate: FTFeedCellDelegate?
    var feed: FTFeedInfo!
    var dataSourceType: DataSourceType = .remote
    var photos = [Photo]()
    var skPhotos = [SKPhoto]()
    var viewerController: ViewerController?
    var optionsController: OptionsController?
    let collectionViewWidth = UIScreen.main.bounds.width - 16 - 16
    var ftReactionType: FTReactionTypes = .love
    
    @IBOutlet weak var userAvatarImageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayoutConstraintHieght: NSLayoutConstraint!
    @IBOutlet weak var commentConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var savedBtn: UIButton!
    
    @IBOutlet weak var commentTableConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var privacyImageView: UIImageView!
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var reactionCountLabel: UILabel!
    
    var datasource: [FTCommentViewModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentTextField.returnKeyType = .done
        commentTextField.delegate = self
        self.selectionStyle = .none
        
        userAvatarImageview.round()
        
        // collection view to display photos/video
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.Identifier)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        userAvatarImageview.addGestureRecognizer(singleTap)
        userAvatarImageview.isUserInteractionEnabled = true
        
        let contentTap = UITapGestureRecognizer(target: self, action: #selector(showDetail))
        contentLabel.addGestureRecognizer(contentTap)
        contentLabel.isUserInteractionEnabled = true
        
        reactionButton.reactionSelector = ReactionSelector()
        reactionButton.config           = ReactionButtonConfig() {
            $0.iconMarging      = 10
            $0.spacing          = 0
            $0.font             = UIFont(name: "HelveticaNeue", size: 0)
            $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
            $0.alignment        = .centerLeft
        }
        
        reactionButton.reactionSelector?.feedbackDelegate = self
        
        // comment tableview
        FTCommentViewModel.register(tableView: commentTableView)
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.separatorStyle = .none
        commentTableView.tableFooterView = UIView()
    }
    
    
    @IBOutlet weak var reactionButton: ReactionButton!
    
    @IBAction func reactionButtonTouchUpAction(_ sender: Any) {
        reactionButton.reaction   = Reaction.facebook.like
        ftReactionType = .love
        if reactionButton.isSelected == false {
            self.delegate?.feedCellDidRemoveReaction(cell: self)
        } else {
            self.delegate?.feedCellDidChangeReactionType(cell: self)
        }
    }
    
    @objc func showUserProfile() {
        guard let username = feed.user?.username else { return }
        self.delegate?.feedCellDidTapUsername(username: username)
    }
    
    @objc func showDetail() {
        self.delegate?.feedCellShowDetail(cell: self)
    }
    
    func renderCell(data: FTFeedViewModel) {
        feed = data.feed
        if let urlString = feed.user?.avatar {
            if let url = URL(string: urlString) {
                self.userAvatarImageview.loadImage(fromURL: url, defaultImage: UIImage.userImage())
            } else {
                self.userAvatarImageview.image = UIImage.userImage()
            }
        } else {
            self.userAvatarImageview.image = UIImage.userImage()
        }
        self.nameLabel.text = feed.user?.last_name
        if let dateString = feed.date {
            self.dateLabel.text = moment(dateString, timeZone: TimeZone(secondsFromGMT: 0)!, locale: .current)?.fromNowFT()
        } else {
            self.dateLabel.text = nil
        }
        self.contentLabel.text = feed.text?.htmlToString
        
        let photoController = PhotosController(dataSourceType: .remote)
        photoController.collectionView?.isScrollEnabled = false
        photos.removeAll()
        skPhotos.removeAll()
        if let type = feed.feedcontent?.display_type {
            guard let imageDatas = feed.feedcontent?.data else { return }
            switch type {
            case 1:
                /*
                 "display_type": 1,
                 "data": [
                 {
                 "id": 108,
                 "image": "https://api.feedtrue.com/media/users/1/9_108.jpg"
                 },
                 {
                 "id": 103,
                 "image": "https://api.feedtrue.com/media/users/1/9_103.jpg"
                 },
                 {
                 "id": 59,
                 "image": "https://api.feedtrue.com/media/users/1/9_59.jpg"
                 }
                 ]
                 */
            for image in imageDatas {
                guard let id = image["id"] else { continue }
                guard let imageDict = image["image"] as? [String: Any] else { continue }
                guard let url = imageDict["src"] as? String else { continue }
                guard let width = imageDict["width"] as? Int else { continue }
                guard let height = imageDict["height"] as? Int else { continue }
                let photo = Photo(id: "\(id)")
                photo.url = url
                photo.width = width
                photo.height = height
                photos.append(photo)
                }
            case 2:
                /*
                 "display_type": 2,
                 "data": [
                 {
                 "id": 11,
                 "featured_image": "https://api.feedtrue.com/media/users/21/video/11/artwork.jpg",
                 "file": "https://api.feedtrue.com/media/users/21/video/11/11.mp4"
                 }
                 ]
                 */
            for image in imageDatas {
                guard let id = image["id"] else { continue }
                let thumbnail = image["thumbnail"] as? String
                let url = image["file"] as? String
                let photo = Photo(id: "\(id)")
                photo.url = url
                photo.type = .video
                photo.thumbnailURL = thumbnail
                photos.append(photo)
                }
            case 3:
                /*
                 "display_type": 3,
                 "data": [
                 {
                 "id": 67,
                 "title": "Gác xếp của tôi",
                 "thumbnail": "https://api.feedtrue.com/media/avatar/article/67.gif",
                 "slug": "gac-xep-cua-toi"
                 }
                 ]
                 */
                for image in imageDatas {
                    guard let id = image["id"] else { continue }
                    let title = image["title"] as? String
                    let thumbnailURL = image["thumbnail"] as? String
                    let slug = image["slug"] as? String
                    guard let videoURL = image["file"] as? String else { continue }
                    let photo = Photo(id: "\(id)")
                    photo.thumbnailURL = thumbnailURL
                    photo.url = videoURL
                    photo.title = title
                    photo.slug = slug
                    photo.type = .video
                    
                    photos.append(photo)
                }
            case 4:
                /*
                 "display_type": 4,
                 "data": [
                 {
                 "id": 56,
                 "user": {
                 "id": 1,
                 "username": "lecongtoan",
                 "full_name": "Công Toàn Lê",
                 "first_name": "Công Toàn",
                 "last_name": "Lê",
                 "avatar": "https://api.feedtrue.com/media/avatar/profile/1/avatar.jpg"
                 },
                 "date": "2018-09-18T07:03:28.041000Z",
                 "feedcontent": {
                 "display_type": 1,
                 "data": [
                 {
                 "id": 108,
                 "image": "https://api.feedtrue.com/media/users/1/9_108.jpg"
                 },
                 {
                 "id": 103,
                 "image": "https://api.feedtrue.com/media/users/1/9_103.jpg"
                 },
                 {
                 "id": 59,
                 "image": "https://api.feedtrue.com/media/users/1/9_59.jpg"
                 }
                 ]
                 */
                for d in imageDatas {
                    guard let feedcontent = d["feedcontent"] as? [String: Any] else { continue }
                    guard let dataArr = feedcontent["data"] as? [[String: Any]] else { continue }
                    for item in dataArr {
                        guard let id = item["id"] else { continue }
                        guard let imageDict = item["image"] as? [String: Any] else { continue }
                        guard let url = imageDict["src"] as? String else { continue }
                        guard let width = imageDict["width"] as? Int else { continue }
                        guard let height = imageDict["height"] as? Int else { continue }
                        let photo = Photo(id: "\(id)")
                        photo.url = url
                        photo.width = width
                        photo.height = height
                        photos.append(photo)
                    }
                }
            default:
                break
            }
        }
        
        // SKPhotoBrowser
        for photo in photos {
            switch photo.type {
            case .image:
                guard let url = photo.url else { continue }
                let skPhoto = SKPhoto.photoWithImageURL(url)
                skPhoto.shouldCachePhotoURLImage = true
                skPhotos.append(skPhoto)
            case .video:
                guard let url = photo.thumbnailURL else { continue }
                let skPhoto = SKPhoto.photoWithImageURL(url)
                skPhoto.shouldCachePhotoURLImage = true
                skPhotos.append(skPhoto)
            }
        }
        
        _ = collectionView
        if photos.count == 0 {
            collectionLayoutConstraintHieght.constant = 0
            data.imageHeight = 0
        } else if photos.count == 1 {
            guard let photo = photos.first else { return }
            var h: CGFloat = collectionViewWidth * (2.0/3.0)
            if let width = photo.width, let height = photo.height {
                NSLog("width: \(width), height: \(height)")
                if width > height {
                    // limit width = screen width / 2
                    h = CGFloat(height) * (2.0 * collectionViewWidth / 3.0) / CGFloat(width)
                } else if width < height {
                    // limit height = 2/3 screen width
                    h = collectionViewWidth
                } else {
                    // width = height
                    h = 2 * collectionViewWidth / 3.0
                }
            }
            collectionLayoutConstraintHieght.constant = h
            data.imageHeight = h
        } else if photos.count > 1 {
            collectionLayoutConstraintHieght.constant = (collectionViewWidth / 3) * CGFloat(ceilf(Float(photos.count) / 3.0))
            data.imageHeight = collectionLayoutConstraintHieght.constant
        }
        self.setNeedsLayout()
        collectionView.reloadData()
        
        // config react icon
        if let reactCount = feed.reactions?.count {
            self.reactionCountLabel.text = reactCount > 0 ? "\(reactCount)" : nil
        } else {
            self.reactionCountLabel.text = nil
        }
        
        if let reactType = feed.request_reacted {
            switch reactType {
            case "LOVE":
                ftReactionType = .love
                reactionButton.reaction   = Reaction.facebook.like
            case "LAUGH":
                ftReactionType = .laugh
                reactionButton.reaction   = Reaction.facebook.laugh
            case "WOW":
                ftReactionType = .wow
                reactionButton.reaction   = Reaction.facebook.wow
            case "SAD":
                ftReactionType = .sad
                reactionButton.reaction   = Reaction.facebook.sad
            case "ANGRY":
                ftReactionType = .angry
                reactionButton.reaction   = Reaction.facebook.angry
            default:
                ftReactionType = .love
                reactionButton.reaction   = Reaction.facebook.like
            }
        }
        
        // config save icon
        if let saved = feed.saved {
            if saved {
                // icon saved
                savedBtn.setImage(UIImage(named: "saved"), for: .normal)
            } else {
                // icon save
                savedBtn.setImage(UIImage(named: "save"), for: .normal)
            }
        } else {
            // icon save
            savedBtn.setImage(UIImage(named: "save"), for: .normal)
        }
        
        // config privacy icon
        /*
         0: Public
         1: Secret
         2: Follower Only
         */
        var privacyType: FTPrivacyType = .follow
        if let privacy = feed.privacy {
            switch privacy {
            case 0:
                privacyType = .public
            case 1:
                privacyType = .secret
            case 2:
                privacyType = .follow
            default:
                break
            }
        }
        privacyImageView.image = UIImage(named: privacyType.rawValue)
        
        if let count = data.feed.comment?.count {
            self.commentCountLabel.text = count > 0 ? "\(count)" : nil
        } else {
            self.commentCountLabel.text = nil
        }
        
        // reset datasource for each cell
        self.datasource = []
        commentTableConstraintHeight.constant = 0
        if let comments = data.feed.comment?.comments {
            for c in comments {
                let commentMV = FTCommentViewModel(comment: c, type: .text)
                if self.datasource.count < 3 {
                    self.datasource.append(commentMV)
                }
            }
            commentTableConstraintHeight.constant = CGFloat(64 * self.datasource.count)
        }
        
        data.commentHeight = commentTableConstraintHeight.constant
        
        self.commentTableView.reloadData()
        // config comment tableview
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func moreBtnPressed(_ sender: Any) {
        
        /*
         Case 1: If feed.editable = false (Case feed owner is not request user), user can be get into these actions:
         Go to feed: Change screen into FEED DETAIL
         Share: Open Share Feed Modal
         See less content: Temporarily open modal: "You wont see this content anymore" and remove this feed out of feed list.
         Report inapproriate: Temporarily open modal: "Successfully reported" and remove this feed out of feed list.
         */
        let gotoFeedAction = UIAlertAction(title: NSLocalizedString("Go to feed", comment: ""), style: .default) { (action) in
            self.delegate?.feeddCellGotoFeed(cell: self)
        }
        
        let shareAction = UIAlertAction(title: NSLocalizedString("Share", comment: ""), style: .default) { (action) in
            self.delegate?.feeddCellShare(cell: self)
        }
        
        let seeLessContentAction = UIAlertAction(title: NSLocalizedString("See less content", comment: ""), style: .default) { (action) in
            self.delegate?.feeddCellSeeLessContent(cell: self)
        }
        
        let reportInapproriate = UIAlertAction(title: NSLocalizedString("Report inapproriate", comment: ""), style: .default) { (action) in
            self.delegate?.feeddCellReportInapproriate(cell: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // user cancel
        }
        
        var actions:[UIAlertAction] = []
        if feed.editable == true {
            /*
             Edit: Open modal Edit
             Permanently Delete: (with text-color Red): DELETE /f/${feedID}/delete/ and remove this feed out of feed list
             */
            let editAction = UIAlertAction(title: NSLocalizedString("Edit", comment: ""), style: .default) { (action) in
                self.delegate?.feeddCellEdit(cell: self)
            }
            
            let permanentlyDeleteAction = UIAlertAction(title: NSLocalizedString("Permanently Delete", comment: ""), style: .destructive) { (action) in
                self.delegate?.feeddCellPermanentlyDelete(cell: self)
                
            }
            actions = [gotoFeedAction, shareAction, seeLessContentAction, reportInapproriate, editAction, permanentlyDeleteAction, cancelAction]
        } else {
            actions = [gotoFeedAction, shareAction, seeLessContentAction, reportInapproriate, cancelAction]
        }
        FTAlertViewManager.defaultManager.showActions(nil, message: nil, actions: actions, view: self)
    }
    
    
    @IBAction func savedTouchUpAction(_ sender: Any) {
        if let saved = feed.saved {
            if saved {
                self.delegate?.feedCellDidUnSave(cell: self)
                self.savedBtn.setImage(UIImage(named: "save"), for: .normal)
                self.feed.saved = false
                return
            }
        }
        self.savedBtn.setImage(UIImage(named: "saved"), for: .normal)
        self.feed.saved = true
        self.delegate?.feedCellDidSave(cell: self)
    }
    
    @IBAction func commentTouchUpAction(_ sender: Any) {
        //self.delegate?.feedCellDidTouchUpComment(cell: self)
        showDetail()
    }
}

extension FTFeedTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.commentTextField.endEditing(true)
        return true
    }
}

extension FTFeedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.Identifier, for: indexPath) as! PhotoCell
        cell.photo = self.photos[indexPath.row]
        let type = cell.photo?.type ?? .image
        switch type {
        case .image:
            if let url = URL(string: cell.photo?.url ?? "") {
                cell.imageView.loadImage(fromURL: url, defaultImage: UIImage.noImage())
                let skphoto = SKPhoto(url: cell.photo!.url!)
                skphoto.loadUnderlyingImageComplete()
            } else {
                cell.imageView.image = UIImage.noImage()
            }
        case .video:
            if let url = URL(string: cell.photo?.thumbnailURL ?? "") {
                cell.imageView.loadImage(fromURL: url, defaultImage: UIImage.noImage())
            } else {
                cell.imageView.image = UIImage.noImage()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionView = self.collectionView else { return }
        
//        self.viewerController = ViewerController(initialIndexPath: indexPath, collectionView: collectionView)
//        self.viewerController!.dataSource = self
//        self.viewerController!.delegate = self
//
//        #if os(iOS)
//        let headerView = HeaderView()
//        headerView.viewDelegate = self
//        self.viewerController?.headerView = headerView
//        let footerView = FooterView()
//        footerView.viewDelegate = self
//        self.viewerController?.footerView = footerView
//        #endif
//
//        //self.present(self.viewerController!, animated: false, completion: nil)
//        if let topVC = UIApplication.topViewController() {
//            topVC.present(self.viewerController!, animated: false, completion: nil)
//        }
//        NSLog("\(#function) at index path: \(indexPath.row)")
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
        if let photo = photos.first, photos.count == 1, photo.type == .video {
            guard let videoURL = photo.url else { return }
            guard let url = URL(string: videoURL) else { return }
            let playerVC = FTPlayerViewController(feed: feed, videoURL: url)
            playerVC.delegate = self
            if let topVC = UIApplication.topViewController() {
                topVC.navigationController?.pushViewController(playerVC, animated: true)
            }
            return
        }
        
        let originImage = cell.imageView.image // some image for baseImage
        
        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: skPhotos, animatedFromView: cell)
        browser.feedInfo = feed
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        if let topVC = UIApplication.topViewController() {
            topVC.present(browser, animated: false, completion: nil)
        }
    }
    
}

extension FTFeedTableViewCell: ViewerControllerDataSource {
    
    func numberOfItemsInViewerController(_: ViewerController) -> Int {
        return self.photos.count
    }
    
    func viewerController(_: ViewerController, viewableAt indexPath: IndexPath) -> Viewable {
        let viewable = self.photos[indexPath.row]
        if let cell = self.collectionView?.cellForItem(at: indexPath) as? PhotoCell, let placeholder = cell.imageView.image {
            viewable.placeholder = placeholder
        }
        
        return viewable
    }
}

extension FTFeedTableViewCell: ViewerControllerDelegate {
    func viewerController(_: ViewerController, didChangeFocusTo _: IndexPath) {}
    
    func viewerControllerDidDismiss(_: ViewerController) {

    }
    
    func viewerController(_: ViewerController, didFailDisplayingViewableAt _: IndexPath, error _: NSError) {
        
    }
    
    func viewerController(_ viewerController: ViewerController, didLongPressViewableAt indexPath: IndexPath) {
        print("didLongPressViewableAt: \(indexPath)")
    }
}

extension FTFeedTableViewCell: OptionsControllerDelegate {
    
    func optionsController(optionsController _: OptionsController, didSelectOption _: String) {
        self.optionsController?.dismiss(animated: true) {
            self.viewerController?.dismiss(nil)
        }
    }
}

extension FTFeedTableViewCell: HeaderViewDelegate {
    
    func headerView(_: HeaderView, didPressClearButton _: UIButton) {
        self.viewerController?.dismiss(nil)
    }
    
    func headerView(_: HeaderView, didPressMenuButton button: UIButton) {
        let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.optionsController = OptionsController(sourceView: button, sourceRect: rect)
        self.optionsController?.delegate = self
        self.viewerController?.present(self.optionsController!, animated: true, completion: nil)
    }
}

extension FTFeedTableViewCell: FooterViewDelegate {
    
    func footerView(_: FooterView, didPressFavoriteButton _: UIButton) {
        FTAlertViewManager.defaultManager.showOkAlert(nil, message: NSLocalizedString("Favorite pressed", comment: ""), handler: nil)
        
    }
    
    func footerView(_: FooterView, didPressDeleteButton _: UIButton) {
        FTAlertViewManager.defaultManager.showOkAlert(nil, message: NSLocalizedString("Delete pressed", comment: ""), handler: nil)
    }
}

extension FTFeedTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if photos.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        if photos.count == 1 {
            let photo = photos[indexPath.row]
            if let width = photo.width, let height = photo.height, photo.type == .image {
                NSLog("\(#function) width: \(width), height: \(height)")
                var h: CGFloat = collectionViewWidth / 2.0
                var w: CGFloat = 2 * collectionViewWidth / 3.0
                    NSLog("width: \(width), height: \(height)")
                    if width > height {
                        // limit width = screen width / 2
                        h = CGFloat(height) * (2.0 * collectionViewWidth / 3.0) / CGFloat(width)
                    } else if width < height {
                        // limit height = 2/3 screen width
                        h = collectionViewWidth
                        w = CGFloat(width) * h / CGFloat(height)
                    } else {
                        // width = height
                        h = 2 * collectionViewWidth / 3.0
                        w = h
                    }
                NSLog("\(#function) size_w: \(w), size_h: \(h)")
                return CGSize(width: w, height: h)
            } else {
                // video
                let h = collectionViewWidth * 2.0 / 3.0
                return CGSize(width: collectionViewWidth, height: h)
            }
            //return CGSize(width: collectionViewWidth / 2, height: collectionViewWidth / 2)
        }
        // 2+ photos
        let h = collectionViewWidth / 3.0
        return CGSize(width: h - 1, height: h - 1)
    }
    
}

extension FTFeedTableViewCell: ReactionFeedbackDelegate {
    func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
        guard let reaction = reactionButton.reactionSelector?.selectedReaction else { return }
        NSLog("\(#function) selected: \(reaction.title)")
        switch reaction.title {
        case "like":
            ftReactionType = .love
        case "laugh":
            ftReactionType = .laugh
        case "wow":
            ftReactionType = .wow
        case "sad":
            ftReactionType = .sad
        case "angry":
            ftReactionType = .angry
        default:
            ftReactionType = .love
        }
        self.delegate?.feedCellDidChangeReactionType(cell: self)
    }
}

extension FTFeedTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = datasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier()) as! FTCommentTextCell
        cell.renderCell(data: content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = datasource[indexPath.row]
        return content.cellHeight()
    }
}

extension FTFeedTableViewCell: SKPhotoBrowserDelegate {
    func feedDidChange(_ browser: SKPhotoBrowser) {
        //guard let feedInfo = browser.feedInfo else { return }
        //renderCell(data: FTFeedViewModel(f: feedInfo))
    }
    
    func didTouchCommentButton(_ browser: SKPhotoBrowser) {
        showDetail()
    }
}

extension FTFeedTableViewCell: PlayerDelegate {
    func feedNeedReload(feed: FTFeedInfo) {
        //renderCell(data: FTFeedViewModel(f: feed))
    }
    
    func feedCommentDidTouchUpAction(feed: FTFeedInfo) {
        showDetail()
    }
}
