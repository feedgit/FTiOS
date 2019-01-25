//
//  FTMenuTableViewCell
//  FeedTrue
//
//  Created by Quoc Le on 10/17/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

@objc protocol FTMenuTableViewCellDelegate:NSObjectProtocol {
    @objc func menuTableViewCell(_ menuCell: FTMenuTableViewCell, didSelectedItemAt index: Int);
    
}

class FTMenuTableViewCell: UITableViewCell,CoolSlidingMenuViewDelegate, BECellRenderImpl {
    typealias CellData = FTMenuViewModel
    weak var delegate: FTMenuTableViewCellDelegate?
    public var countRow:Int! 
    public var countCol:Int!
    public var pgCtrlNormalColor: UIColor!
    public var pgCtrlSelectedColor: UIColor!
    public var pgCtrlShouldHidden: Bool!
    
    var slidingMenuView:CoolSlidingMenuView = CoolSlidingMenuView()
    public var arrMenu:Array<Any> = [] {
        willSet {
            slidingMenuView.pgCtrl.isHidden = pgCtrlShouldHidden
            slidingMenuView.pgCtrlNormalColor = pgCtrlNormalColor
            slidingMenuView.pgCtrlSelectedColor = pgCtrlSelectedColor
            slidingMenuView.countRow = countRow
            slidingMenuView.countCol = countCol
        }
        didSet {
            
            slidingMenuView.arrMenu = arrMenu
        }
    }
    
    func renderCell(data: FTMenuViewModel) {
        pgCtrlShouldHidden = data.pgCtrlShouldHidden
        pgCtrlNormalColor = data.pgCtrlNormalColor
        pgCtrlSelectedColor = data.pgCtrlSelectedColor
        countRow = data.countRow
        countCol = data.countCol
        
        arrMenu = data.arrMenu
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        slidingMenuView = CoolSlidingMenuView()
        slidingMenuView.delegate = self
        self.selectionStyle = .none
        self.contentView.addSubview(slidingMenuView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        slidingMenuView.contentMode = .scaleAspectFit
        slidingMenuView.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.size.width, height: self.contentView.bounds.size.height)
    }
    
    // MARK: CoolSlidingMenuDelegate
    func coolSlidingMenu(_ slidingBoxMenu: CoolSlidingMenuView, didSelectedItemAt index: Int) {
        print("\(#function)\(index)")
        delegate?.menuTableViewCell(self, didSelectedItemAt: index)
    }
    
}
