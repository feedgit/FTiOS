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
        case setting
        
        var cellIdentifier: String {
            get {
                switch self {
                case .profile:
                    return "FTUserDashBoardProfileCell"
                case .follow:
                    return "FTUserDashBoardFollowCell"
                case .setting:
                    return "FTUserDashBoardSettingCell"
                }
            }
        }
    }
    
    var profile: FTUserProfileResponse
    var type: UserDashBoardType
    var dataDidChange: (()->())?
    
    init(profile p: FTUserProfileResponse, type: UserDashBoardType) {
        self.profile = p
        self.type = type
    }
    
    func cellIdentifier() -> String {
        return type.cellIdentifier
    }
    
    func cellHeight() -> CGFloat {
        switch type {
        case .profile:
            return 100
        case .follow:
            return 64
        case .setting:
            return 44
        }
    }
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: UserDashBoardType.profile.cellIdentifier, bundle: nil), forCellReuseIdentifier: UserDashBoardType.profile.cellIdentifier)
        
        tableView.register(UINib(nibName: UserDashBoardType.follow.cellIdentifier, bundle: nil), forCellReuseIdentifier: UserDashBoardType.follow.cellIdentifier)
        
        tableView.register(UINib(nibName: UserDashBoardType.setting.cellIdentifier, bundle: nil), forCellReuseIdentifier: UserDashBoardType.setting.cellIdentifier)
    }
}

class FTUserDashBoardSettingViewModel: FTUserDashBoardViewModel {
    var title: String
    var icon: UIImage
    
    init(title t: String, icon ic: UIImage, profile p: FTUserProfileResponse) {
        self.title = t
        self.icon = ic
        super.init(profile: p, type: .setting)
    }
}


