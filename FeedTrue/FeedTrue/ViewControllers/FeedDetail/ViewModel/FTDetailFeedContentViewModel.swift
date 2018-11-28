//
//  FTDetailFeedContentViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/26/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTDetailFeedContentViewModel: BECellDataSource {
    static let cellId = "FTDetailContentTableViewCell"
    var content: String
    
    init(content c: String) {
        content = c
    }
    
    func cellIdentifier() -> String {
        return FTDetailFeedContentViewModel.cellId
    }
    
    func cellHeight() -> CGFloat {
        return textViewHeigh()
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func textViewHeigh() -> CGFloat {
        let width = UIScreen.main.bounds.width - 8 // textview padding left + right
        let calculationView = UITextView()
        calculationView.font = UIFont.systemFont(ofSize: 17)
        calculationView.text = content
        let size = calculationView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        return size.height
    }
    

}
