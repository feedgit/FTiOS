//
//  ChatViewController.swift
//  SwiftExample
//
//  Created by Dan Leonard on 5/11/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SocketIO
import SwiftMoment
import SVPullToRefresh

public enum Setting: String{
    case removeBubbleTails = "Remove message bubble tails"
    case removeSenderDisplayName = "Remove sender Display Name"
    case removeAvatar = "Remove Avatars"
}

class ChatViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    let defaults = UserDefaults.standard
    var conversation: Conversation?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    fileprivate var displayName: String!
    var contact: FTContact!
    var socket: SocketIOClient!
    var manager: SocketManager!
    var users: [UserProfile] = []
    var nextURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation
        setupBackButton()
        
        /**
         *  Override point:
         *
         *  Example of how to cusomize the bubble appearence for incoming and outgoing messages.
         *  Based on the Settings of the user display two differnent type of bubbles.
         *
         */
        
        if defaults.bool(forKey: Setting.removeBubbleTails.rawValue) {
            // Make taillessBubbles
            incomingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: .zero)?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
            outgoingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: .zero).outgoingMessagesBubbleImage(with: UIColor.lightGray)
            
        }
        else {
            // Bubbles with tails
            incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
            outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
        }
        
        /**
         *  Example on showing or removing Avatars based on user settings.
         */
        
        if defaults.bool(forKey: Setting.removeAvatar.rawValue) {
            collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
            collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        } else {
            collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
            collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        }
        
        // Show Button to simulate incoming messages
        self.navigationItem.rightBarButtonItem = nil //UIBarButtonItem(image: UIImage.jsq_defaultTypingIndicator(), style: .plain, target: self, action: #selector(receiveMessagePressed))
        
        // This is a beta feature that mostly works but to make things more stable it is diabled.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        automaticallyScrollsToMostRecentMessage = true
        loadMessages()
        setupSocket()
        
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        
        self.collectionView.addPullToRefresh {
            self.loadMore()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = NSLocalizedString(contact.user?.username ?? "Chat", comment: "")
    }
    
    func setupBackButton() {
//        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
//        navigationItem.leftBarButtonItem = backButton
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
    }
    @objc func backButtonTapped() {
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func loadMessages() {
        WebService.default.getMessage(roomID: contact.room?.id ?? 0) { (success, messageResponse) in
            if success {
                print("Load message successful \(messageResponse.debugDescription)")
                self.nextURL = messageResponse?.next
                // add message
                guard let listMessages = messageResponse?.messages else { return }
                //self.dataSource.addMessages(messages.reversed())
                for item in listMessages {
                    guard let senderID = item.user?.id else { continue }
                    guard let senderDisplauName = item.user?.last_name else { continue }
                    var date = Date()
                    if let createAt = item.createdAt {
                        date = moment(createAt)?.date ?? Date()
                    }
                    guard let text = item.text else { continue }
                    guard let msg = JSQMessage(senderId: "\(senderID)", senderDisplayName: senderDisplauName, date: date, text: text.htmlToString) else { continue }
                    self.messages.append(msg)
                    
                    if let u = item.user {
                        self.addUser(user: u)
                    }
                }
                
                self.messages.reverse()
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                print("Load message failure")
            }
        }
    }
    
    func loadMore() {
        print("Load earlier messages triggered by scroll!")
        guard let url = self.nextURL else {
            self.collectionView.showsPullToRefresh = false
            return
        }
        guard messages.count > 0 else { return }
        
        // start animation
        self.collectionView.collectionViewLayout.springinessEnabled = false
        self.collectionView.pullToRefreshView.startAnimating()
        
        WebService.default.getMoreMessage(nextString: url) { (success, messageResponse) in
            
            // stop animation
            DispatchQueue.main.async {
                self.collectionView.pullToRefreshView.stopAnimating()
                self.collectionView.collectionViewLayout.springinessEnabled = true
            }
            let oldBottomOffset = self.collectionView.contentSize.height - self.collectionView.contentOffset.y
            if success {
                self.nextURL = messageResponse?.next
                // add message
                guard let listMessages = messageResponse?.messages else { return }
                //self.dataSource.addMessages(messages.reversed())
                for item in listMessages {
                    guard let senderID = item.user?.id else { continue }
                    guard let senderDisplauName = item.user?.last_name else { continue }
                    var date = Date()
                    if let createAt = item.createdAt {
                        date = moment(createAt)?.date ?? Date()
                    }
                    guard let text = item.text else { continue }
                    guard let msg = JSQMessage(senderId: "\(senderID)", senderDisplayName: senderDisplauName, date: date, text: text.htmlToString) else { continue }
                    self.messages.insert(msg, at: 0)
                    
                    if let u = item.user {
                        self.addUser(user: u)
                    }
                }
                
                DispatchQueue.main.async {
                    self.finishReceivingMessage(animated: false)
                    self.collectionView.layoutIfNeeded()
                    self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - oldBottomOffset)
                }
            } else {
                print("Load more message failure")
            }
        }
        
    }
    
    private func addUser(user u: UserProfile) {
        if self.users.count == 0 {
            self.users.append(u)
        } else {
            for user in self.users {
                if user.username != u.username {
                    self.users.append(u)
                    break
                }
            }
        }
    }
    
    private func getUserAvatar(userID id: Int) -> String? {
        for user in self.users {
            if user.id == id {
                return user.avatar
            }
        }
        return nil
    }
    
    private func setupSocket() {
        manager = SocketManager(socketURL: URL(string: "https://chapi.feedtrue.com")!, config: [.log(true), .compress, .forcePolling(true)])
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            let id = self.contact.room?.id ?? 0
            let user = self.contact.user?.username ?? ""
            self.socket.emit("openRoom", ["room_id": id, "user": user])
        }
        
        self.socket.on("updateRoom_\(self.contact.room?.id ?? 0)") { (data, ack) in
            print("updateRoom with data \(data)")
            if let array = data as? [[String: Any]] {
                for item in array {
                    //self.dataSource.addTextMessage(text.htmlToString, isIncomming: true)
                    //guard let senderID = item.id else { continue }
                    //guard let senderDisplauName = item.user?.last_name else { continue }
                    //let date = Date()
                    guard let updatedAt = item["created_at"] as? String else { continue }
                    guard let date = moment(updatedAt)?.date else { continue }
                    guard let text = item["text"] as? String else { continue }
                    guard let user = item["user"] as? [String: Any] else { continue }
                    guard let senderID = user["id"] as? Int else { continue }
                    guard let msg = JSQMessage(senderId: "\(senderID)", senderDisplayName: "senderDisplauName", date: date, text: text.htmlToString) else { continue }
                    self.messages.append(msg)
                    
                    // TODO: check & add user
                    
                }
            }
        }
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print("socket disconnect")
        }
        
        socket.on(clientEvent: .error) { (data, ack) in
            print("socket error")
        }
        
        socket.connect()
    }
    
    private func sendMessage(_ text: String) {
        guard let roomID = contact.room?.id else { return }
        //guard let userID = contact.user?.id else { return }
        //self.socket.emit("send-message", ["text": text, "room_id": roomID, "user_id": userID])
        WebService.default.sendMessage(text: text, roomID: roomID) { (success, message) in
            if success {
                NSLog("\(#function) success \(message.debugDescription)")
            } else {
                NSLog("\(#function) failure \(message.debugDescription)")
                // TODO : update message status to failure
            }
        }
    }

    
    @objc func receiveMessagePressed(_ sender: UIBarButtonItem) {
        /**
         *  DEMO ONLY
         *
         *  The following is simply to simulate received messages for the demo.
         *  Do not actually do this.
         */
        
        /**
         *  Show the typing indicator to be shown
         */
        self.showTypingIndicator = !self.showTypingIndicator
        
        /**
         *  Scroll to actually view the indicator
         */
        self.scrollToBottom(animated: true)
        
        /**
         *  Copy last sent message, this will be the new "received" message
         */
        var copyMessage = self.messages.last?.copy()
        
        if (copyMessage == nil) {
            copyMessage = JSQMessage(senderId: AvatarIdJobs, displayName: getName(User.Jobs), text: "First received!")
        }
            
        var newMessage:JSQMessage!
        var newMediaData:JSQMessageMediaData!
        var newMediaAttachmentCopy:AnyObject?
        
        if (copyMessage! as AnyObject).isMediaMessage() {
            /**
             *  Last message was a media message
             */
            let copyMediaData = (copyMessage! as AnyObject).media
            
            switch copyMediaData {
            case is JSQPhotoMediaItem:
                let photoItemCopy = (copyMediaData as! JSQPhotoMediaItem).copy() as! JSQPhotoMediaItem
                photoItemCopy.appliesMediaViewMaskAsOutgoing = false
                
                newMediaAttachmentCopy = UIImage(cgImage: photoItemCopy.image!.cgImage!)
                
                /**
                 *  Set image to nil to simulate "downloading" the image
                 *  and show the placeholder view5017
                 */
                photoItemCopy.image = nil;
                
                newMediaData = photoItemCopy
            case is JSQLocationMediaItem:
                let locationItemCopy = (copyMediaData as! JSQLocationMediaItem).copy() as! JSQLocationMediaItem
                locationItemCopy.appliesMediaViewMaskAsOutgoing = false
                newMediaAttachmentCopy = locationItemCopy.location!.copy() as AnyObject?
                
                /**
                 *  Set location to nil to simulate "downloading" the location data
                 */
                locationItemCopy.location = nil;
                
                newMediaData = locationItemCopy;
            case is JSQVideoMediaItem:
                let videoItemCopy = (copyMediaData as! JSQVideoMediaItem).copy() as! JSQVideoMediaItem
                videoItemCopy.appliesMediaViewMaskAsOutgoing = false
                newMediaAttachmentCopy = (videoItemCopy.fileURL! as NSURL).copy() as AnyObject?
                
                /**
                 *  Reset video item to simulate "downloading" the video
                 */
                videoItemCopy.fileURL = nil;
                videoItemCopy.isReadyToPlay = false;
                
                newMediaData = videoItemCopy;
            case is JSQAudioMediaItem:
                let audioItemCopy = (copyMediaData as! JSQAudioMediaItem).copy() as! JSQAudioMediaItem
                audioItemCopy.appliesMediaViewMaskAsOutgoing = false
                newMediaAttachmentCopy = (audioItemCopy.audioData! as NSData).copy() as AnyObject?
                
                /**
                 *  Reset audio item to simulate "downloading" the audio
                 */
                audioItemCopy.audioData = nil;
                
                newMediaData = audioItemCopy;
            default:
                assertionFailure("Error: This Media type was not recognised")
            }
            
            newMessage = JSQMessage(senderId: AvatarIdJobs, displayName: getName(User.Jobs), media: newMediaData)
        }
        else {
            /**
             *  Last message was a text message
             */
            
            newMessage = JSQMessage(senderId: AvatarIdJobs, displayName: getName(User.Jobs), text: (copyMessage! as AnyObject).text)
        }
        
        /**
         *  Upon receiving a message, you should:
         *
         *  1. Play sound (optional)
         *  2. Add new JSQMessageData object to your data source
         *  3. Call `finishReceivingMessage`
         */
        
        self.messages.append(newMessage)
        self.finishReceivingMessage(animated: true)
        
        if newMessage.isMediaMessage {
            /**
             *  Simulate "downloading" media
             */
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                /**
                 *  Media is "finished downloading", re-display visible cells
                 *
                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
                 *
                 *  Reload the specific item, or simply call `reloadData`
                 */
                
                switch newMediaData {
                case is JSQPhotoMediaItem:
                    (newMediaData as! JSQPhotoMediaItem).image = newMediaAttachmentCopy as? UIImage
                    self.collectionView!.reloadData()
                case is JSQLocationMediaItem:
                    (newMediaData as! JSQLocationMediaItem).setLocation(newMediaAttachmentCopy as? CLLocation, withCompletionHandler: {
                        self.collectionView!.reloadData()
                    })
                case is JSQVideoMediaItem:
                    (newMediaData as! JSQVideoMediaItem).fileURL = newMediaAttachmentCopy as? URL
                    (newMediaData as! JSQVideoMediaItem).isReadyToPlay = true
                    self.collectionView!.reloadData()
                case is JSQAudioMediaItem:
                    (newMediaData as! JSQAudioMediaItem).audioData = newMediaAttachmentCopy as? Data
                    self.collectionView!.reloadData()
                default:
                    assertionFailure("Error: This Media type was not recognised")
                }
            }
        }
    }
    
    // MARK: JSQMessagesViewController method overrides
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        
        guard let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text) else { return }
        self.messages.append(message)
        self.finishSendingMessage(animated: true)
        self.sendMessage(text)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Send photo", style: .default) { (action) in
            /**
             *  Create fake photo
             */
            guard let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate")) else { return }
            self.addMedia(photoItem)
        }
        
        let locationAction = UIAlertAction(title: "Send location", style: .default) { (action) in
            /**
             *  Add fake location
             */
            let locationItem = self.buildLocationItem()
            
            self.addMedia(locationItem)
        }
        
        let videoAction = UIAlertAction(title: "Send video", style: .default) { (action) in
            /**
             *  Add fake video
             */
            let videoItem = self.buildVideoItem()
            
            self.addMedia(videoItem)
        }
        
        let audioAction = UIAlertAction(title: "Send audio", style: .default) { (action) in
            /**
             *  Add fake audio
             */
            let audioItem = self.buildAudioItem()
            
            self.addMedia(audioItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(photoAction)
        sheet.addAction(locationAction)
        sheet.addAction(videoAction)
        sheet.addAction(audioAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    func buildVideoItem() -> JSQVideoMediaItem {
        let videoURL = URL(fileURLWithPath: "file://")
        
        guard let videoItem = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true) else { return JSQVideoMediaItem() }
        
        return videoItem
    }
    
    func buildAudioItem() -> JSQAudioMediaItem {
        let sample = Bundle.main.path(forResource: "jsq_messages_sample", ofType: "m4a")
        let audioData = try? Data(contentsOf: URL(fileURLWithPath: sample!))
        
        let audioItem = JSQAudioMediaItem(data: audioData)
        
        return audioItem
    }
    
    func buildLocationItem() -> JSQLocationMediaItem {
        let ferryBuildingInSF = CLLocation(latitude: 37.795313, longitude: -122.393757)
        
        let locationItem = JSQLocationMediaItem()
        locationItem.setLocation(ferryBuildingInSF) {
            self.collectionView!.reloadData()
        }
        
        return locationItem
    }
    
    func addMedia(_ media:JSQMediaItem) {
        guard let message = JSQMessage(senderId: self.senderId(), displayName: self.senderDisplayName(), media: media) else { return }
        self.messages.append(message)
        
        //Optional: play sent sound
        
        self.finishSendingMessage(animated: true)
    }
    
    
    //MARK: JSQMessages CollectionView DataSource
    
    override func senderId() -> String {
        let senderID = contact.user?.id ?? 0
        return "\(senderID)"
    }
    
    override func senderDisplayName() -> String {
        let displayName = contact.user?.last_name ?? ""
        return displayName//getName(.Wozniak)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        return messages[indexPath.item].senderId == self.senderId() ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = messages[indexPath.item]
        return getAvatar(message.senderId)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        // Displaying names above messages
        //Mark: Removing Sender Display Name
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         */
        if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
            return nil
        }
        
        if message.senderId == self.senderId() {
            return nil
        }

        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         */
        if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
            return 0.0
        }
        
        /**
         *  iOS7-style sender name labels
         */
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.senderId() {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        let senderId: Int = Int(message.senderId) ?? 0
        if let userAvatarURLString = getUserAvatar(userID: senderId) {
            cell.avatarImageView.loadImage(fromURL: URL(string: userAvatarURLString))
        } else {
            cell.avatarImageView.image = UIImage.userImage()
        }
        
        cell.avatarImageView.round()
        return cell
    }
    
}
