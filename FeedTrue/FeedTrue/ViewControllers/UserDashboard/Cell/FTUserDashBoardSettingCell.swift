//
//  FTUserDashBoardSettingCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
enum SettingType {
    case settings
    case logout
}

protocol UserDashBoardSettingDelegate {
    func userDashBoardSettingDidTouchUpAction(type: SettingType)
}

class FTUserDashBoardSettingCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTUserDashBoardSettingViewModel
    
    var delegate: UserDashBoardSettingDelegate?
    var type: SettingType = .settings
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        self.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTouchUp))
        self.addGestureRecognizer(singleTap)
    }
    
    func renderCell(data: FTUserDashBoardSettingViewModel) {
        settingImageView.image = data.icon
        label.text = data.title
        type = data.settingType
    }
    
    @objc func didTouchUp() {
        self.delegate?.userDashBoardSettingDidTouchUpAction(type: type)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
