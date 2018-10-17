//
//  CoolSlidingMenuManager.swift
//  CoolSlidingMenu
//
//  Created by 陈波 on 2017/7/15.
//  Copyright © 2017年 陈波. All rights reserved.
//

import UIKit

class CoolSlidingMenuManager: NSObject {
    static public let manager = CoolSlidingMenuManager()
    func convertDirectionCount(Number number:Int, RowCount rowCount: Int, ColCount colCount: Int) -> Int {
        let tempH = number / (colCount * rowCount)
        let tempL = number % (colCount * rowCount)
        let result:Int = tempL - (tempL / rowCount) * (rowCount - 1) + tempL % rowCount * (colCount - 1) + tempH * (colCount * rowCount)
        return result
    }

}
