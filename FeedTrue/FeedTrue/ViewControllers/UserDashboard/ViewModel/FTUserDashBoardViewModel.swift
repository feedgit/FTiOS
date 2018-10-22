//
//  FTUserDashBoardViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTUserDashBoardViewModel: BECellDataSource {
    enum UserDashBoardType {
        case profile
        case follow
        case menu
        case setting
        
        var cellIdentifier: String {
            get {
                switch self {
                case .profile:
                    return "FTUserDashBoardProfileCell"
                case .follow:
                    return "FTUserDashBoardFollowCell"
                case .menu:
                    return "FTMenuTableViewCell"
                case .setting:
                    return "FTUserDashBoardSettingCell"
                }
            }
        }
    }
    
    var profile: FTUserProfileResponse?
    var type: UserDashBoardType
    var dataDidChange: (()->())?
    
    init(type: UserDashBoardType) {
        self.type = type
    }
    
    func cellIdentifier() -> String {
        return type.cellIdentifier
    }
    
    func cellHeight() -> CGFloat {
        switch type {
        case .profile:
            return 120
        case .follow:
            return 72
        case .menu:
            return 50
        case .setting:
            return 64
        }
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: UserDashBoardType.profile.cellIdentifier, bundle: nil), forCellReuseIdentifier: UserDashBoardType.profile.cellIdentifier)
        
        tableView.register(UINib(nibName: UserDashBoardType.follow.cellIdentifier, bundle: nil), forCellReuseIdentifier: UserDashBoardType.follow.cellIdentifier)
        
        tableView.register(FTMenuTableViewCell.self, forCellReuseIdentifier: UserDashBoardType.menu.cellIdentifier)
        
        tableView.register(UINib(nibName: UserDashBoardType.setting.cellIdentifier, bundle: nil), forCellReuseIdentifier: UserDashBoardType.setting.cellIdentifier)
    }
}

class FTUserDashBoardSettingViewModel: FTUserDashBoardViewModel {
    var title: String
    var icon: UIImage
    
    init(title t: String, icon ic: UIImage) {
        self.title = t
        self.icon = ic
        super.init(type: .setting)
    }
}

class FTUserDashBoardMenuViewModel: FTUserDashBoardViewModel {
    public var arrMenu:Array<Any>
    
    init(arr: Array<Any>) {
        self.arrMenu = arr
        super.init(type: .menu)
    }
}


