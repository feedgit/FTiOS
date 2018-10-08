//
//  FTCommentViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/6/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTCommentViewModel: BECellDataSource {
    enum CommentType {
        case text
        
        var cellIdentifier: String {
            get {
                switch self {
                case .text:
                    return "FTCommentTextCell"
                }
            }
        }
    }
    
    var comment: FTCommentMappable
    var type: CommentType = .text
    var dataDidChange: (()->())?
    var reply: ((FTCommentViewModel?) -> ())?
    var more: ((FTCommentViewModel?) -> ())?
    
    init(comment: FTCommentMappable, type: CommentType) {
        self.comment = comment
        self.type = type
    }
    
    func cellIdentifier() -> String {
        return type.cellIdentifier
    }
    
    var preferCellHeight = CGFloat(64)
    func cellHeight() -> CGFloat {
        return preferCellHeight
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: CommentType.text.cellIdentifier, bundle: nil), forCellReuseIdentifier: CommentType.text.cellIdentifier)
    }
}
