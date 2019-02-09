//
//  FTSwitchControlTableViewCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/31/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit
@objc protocol SwitchControlCellDelegate {
    func switchStateDidChange(isOn: Bool)
}

class FTSwitchControlTableViewCell: UITableViewCell, BECellRenderImpl {
    typealias CellData = FTSwitchViewModel
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    var contentData: FTSwitchViewModel!
    var delegate: SwitchControlCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        switchControl.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
    }
    
    func renderCell(data: FTSwitchViewModel) {
        contentData = data
        iconImageView.image = UIImage(named: contentData.imageName)
        titleLabel.text = contentData.title
        switchControl.setOn(contentData.isOn, animated: true)
    }
    
    @objc func switchStateDidChange(_ sender: UISwitch){
        self.delegate?.switchStateDidChange(isOn: sender.isOn)
        if (sender.isOn == true){
            print("UISwitch state is now ON")
        }
        else{
            print("UISwitch state is now Off")
        }
    }
}
