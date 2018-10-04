//
//  FTProfileEditGenderCell.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/4/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTProfileEditGenderCell: UITableViewCell, BECellRenderImpl {

    typealias CellData = FTGenderViewModel
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genderBtn: UIButton!
    var items: [DropdownItem] = []
    var menuView: DropUpMenu!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let item1 = DropdownItem(title: "UnIdentified")
        let item2 = DropdownItem(title: "Male")
        let item3 = DropdownItem(title: "Female")
        
        items = [item1, item2, item3]
        menuView = DropUpMenu(items: items, selectedRow: 0, bottomOffsetY: 0)
        menuView.delegate = self
        genderBtn.titleEdgeInsets.left = 8
        genderBtn.layer.borderWidth = 1
        genderBtn.layer.borderColor = UIColor.lightGray.cgColor
        genderBtn.layer.cornerRadius = 4
        genderBtn.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var contentData: FTGenderViewModel?
    func renderCell(data: FTGenderViewModel) {
        contentData = data
        titleLabel.text = data.title
        genderBtn.setTitle(data.prefil, for: .normal)
    }
    
    @IBAction func genderBtnTouchUpAction(_ sender: Any) {
        menuView.showMenu()
    }
}

extension FTProfileEditGenderCell: DropUpMenuDelegate {
    func dropUpMenu(_ dropUpMenu: DropUpMenu, didSelectRowAt indexPath: IndexPath) {
        genderBtn.setTitle(items[indexPath.row].title, for: .normal)
    }
}
