//
//  FTMenuViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/18/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTMenuViewModel: BECellDataSource {
    static let cellIdentifier = "FTMenuTableViewCell"
    func cellIdentifier() -> String {
        return FTMenuViewModel.cellIdentifier
    }
    
    func cellHeight() -> CGFloat {
        return (UIScreen.main.bounds.size.width / CGFloat(countCol)) * CGFloat(countRow) + 4
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    public var countRow:Int = 0
    public var countCol:Int = 0
    public var pgCtrlNormalColor: UIColor = .gray
    public var pgCtrlSelectedColor: UIColor = .black
    public var pgCtrlShouldHidden: Bool = true
    
    public var arrMenu:Array<Any>
    init(arrMenu a: Array<Any>) {
        arrMenu = a
    }
}
