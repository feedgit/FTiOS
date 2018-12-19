/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import UIKit
import Chatto
import ChattoAdditions
import SocketIO

class DemoChatViewController: BaseChatViewController {

    var messageSender: DemoChatMessageSender!
    let messagesSelector = BaseMessagesSelector()
    var socket: SocketIOClient!
    var manager: SocketManager!
    var contact: FTContact!

    var dataSource: DemoChatDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.messageSender = self.dataSource.messageSender
        }
    }

    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = contact.user?.last_name ?? "Chat"
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        
        self.messagesSelector.delegate = self
        self.chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
        
        loadMessages()
        setupSocket()
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func loadMessages() {
        WebService.default.getMessage(roomID: contact.room?.id ?? 0) { (success, messageResponse) in
            if success {
                print("Load message successful \(messageResponse.debugDescription)")
                // add message
                guard let messages = messageResponse?.messages else { return }
                self.dataSource.addMessages(messages.reversed())
            } else {
                print("Load message failure")
            }
        }
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
                    if let text = item["text"] as? String {
                        self.dataSource.addTextMessage(text.htmlToString, isIncomming: true)
                    }
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

    var chatInputPresenter: BasicChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {

        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()

        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
            interactionHandler: DemoPhotoMessageHandler(baseHandler: self.baseMessageHandler)
        )
        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()

        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter],
            DemoPhotoMessageModel.chatItemType: [photoMessagePresenter],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()]
        ]
    }

    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
        return items
    }

    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }

    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            self?.dataSource.addPhotoMessage(image)
        }
        return item
    }
}

extension DemoChatViewController: MessagesSelectorDelegate {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }

    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}
