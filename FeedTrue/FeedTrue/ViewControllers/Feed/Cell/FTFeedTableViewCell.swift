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
}

public enum FTReactionTypes: String {
    case love = "LOVE"
    case laugh = "LAUGH"
    case wow = "WOW"
    case sad = "SAD"
    case angry = "ANGRY"
}

class FTFeedTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTFeedViewModel
    weak var delegate: FTFeedCellDelegate?
    var feed: FTFeedInfo!
    var dataSourceType: DataSourceType = .remote
    var photos = [Photo]()
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
    
    @IBOutlet weak var savedBtn: UIButton!
    

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
        
        reactionButton.reactionSelector = ReactionSelector()
        reactionButton.config           = ReactionButtonConfig() {
            $0.iconMarging      = 10
            $0.spacing          = 0
            $0.font             = UIFont(name: "HelveticaNeue", size: 0)
            $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
            $0.alignment        = .centerLeft
        }
        
        reactionButton.reactionSelector?.feedbackDelegate = self
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
    
    func renderCell(data: FTFeedViewModel) {
        feed = data.feed
        if let urlString = feed.user?.avatar {
            if let url = URL(string: urlString) {
                self.userAvatarImageview.loadImage(fromURL: url)
            }
        } else {
            self.userAvatarImageview.image = UIImage(named: "1000x1000")
        }
        self.nameLabel.text = feed.user?.full_name
        if let dateString = feed.date {
            self.dateLabel.text = moment(dateString)?.fromNow()
        } else {
            self.dateLabel.text = nil
        }
        self.contentLabel.text = feed.text?.htmlToString
        
        let photoController = PhotosController(dataSourceType: .remote)
        photoController.collectionView?.isScrollEnabled = false
        photos.removeAll()
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
                let url = image["image"] as? String
                let photo = Photo(id: "\(id)")
                photo.url = url
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
                    let photo = Photo(id: "\(id)")
                    photo.url = thumbnailURL
                    photo.title = title
                    photo.slug = slug
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
                    for i in dataArr {
                        guard let id = i["id"] else { continue }
                        let url = i["image"] as? String
                        let photo = Photo(id: "\(id)")
                        photo.url = url
                        photos.append(photo)
                    }
                }
            default:
                break
            }
        }
        
        _ = collectionView
        if photos.count == 0 {
            collectionLayoutConstraintHieght.constant = 0
        } else if photos.count == 1 {
            let h = collectionViewWidth * (9.0/16.0)
            collectionLayoutConstraintHieght.constant = h
        } else if photos.count >= 2 {
            collectionLayoutConstraintHieght.constant = collectionViewWidth / 2
        }
        collectionView.reloadData()
        
        // config react icon
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
                savedBtn.backgroundColor = UIColor.navigationBarColor()
            } else {
                // icon save
                savedBtn.backgroundColor = .clear
            }
        } else {
            // icon save
            savedBtn.backgroundColor = .clear
        }
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
                self.savedBtn.backgroundColor = .clear
                self.feed.saved = false
                return
            }
        }
        self.savedBtn.backgroundColor = UIColor.navigationBarColor()
        self.feed.saved = true
        self.delegate?.feedCellDidSave(cell: self)
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
        return photos.count > 2 ? 2 : photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.Identifier, for: indexPath) as! PhotoCell
        cell.photo = self.photos[indexPath.row]
        let type = cell.photo?.type ?? .image
        switch type {
        case .image:
            if let url = URL(string: cell.photo?.url ?? "") {
                cell.imageView.loadImage(fromURL: url)
            } else {
                cell.imageView.image = nil
            }
        case .video:
            if let url = URL(string: cell.photo?.thumbnailURL ?? "") {
                cell.imageView.loadImage(fromURL: url)
            } else {
                cell.imageView.image = nil
            }
        }
        if photos.count > 2 && indexPath.row == 1 {
            cell.moreLabel.text = "+\(photos.count - 2)"
            cell.moreLabel.isHidden = false
        } else {
            cell.moreLabel.text = nil
            cell.moreLabel.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionView = self.collectionView else { return }
        
        self.viewerController = ViewerController(initialIndexPath: indexPath, collectionView: collectionView)
        self.viewerController!.dataSource = self
        self.viewerController!.delegate = self
        
        #if os(iOS)
        let headerView = HeaderView()
        headerView.viewDelegate = self
        self.viewerController?.headerView = headerView
        let footerView = FooterView()
        footerView.viewDelegate = self
        self.viewerController?.footerView = footerView
        #endif
        
        //self.present(self.viewerController!, animated: false, completion: nil)
        NSLog("\(#function) at index path: \(indexPath.row)")
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
            return CGSize(width: collectionViewWidth, height: (9.0/16.0) * collectionViewWidth)
        }
        // 2+ photos
        let h = collectionViewWidth / 2.0
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
