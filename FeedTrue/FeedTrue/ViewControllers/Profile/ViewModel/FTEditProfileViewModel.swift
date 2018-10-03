//
//  FTEditProfileViewModel.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/2/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTEditProfileViewModel: BECellDataSource {
    enum EditType {
        case singleLine
        case gender
        case dob
        case multipleLines
        
        var cellIdentifier: String {
            get {
                switch self {
                case .singleLine:
                    return "FTProfileEditSingleLineCell"
                case .gender:
                    return "FTProfileEditGenderCell"
                case .dob:
                    return "FTProfileEditDOBCell"
                case .multipleLines:
                    return "FTProfileEditMultipleLineCellTableViewCell"
                }
            }
        }
    }
    
    var title: String
    var type: EditType
    
    init(title: String, type: EditType) {
        self.title = title
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
        tableView.register(UINib(nibName: EditType.singleLine.cellIdentifier, bundle: nil), forCellReuseIdentifier: EditType.singleLine.cellIdentifier)
        
        tableView.register(UINib(nibName: EditType.gender.cellIdentifier, bundle: nil), forCellReuseIdentifier: EditType.gender.cellIdentifier)
        
        tableView.register(UINib(nibName: EditType.dob.cellIdentifier, bundle: nil), forCellReuseIdentifier: EditType.dob.cellIdentifier)
        
        tableView.register(UINib(nibName: EditType.multipleLines.cellIdentifier, bundle: nil), forCellReuseIdentifier: EditType.multipleLines.cellIdentifier)
    }
}

class FTSingleLineViewModel: FTEditProfileViewModel {
    var prefil: String? {
        get {
            return outputSingleLine
        }
    }
    var outputSingleLine: String?
    
    init(title t: String, prefilSingleLine text: String?) {
        outputSingleLine = text
        
        super.init(title: t, type: .singleLine)
    }
}

class FTGenderViewModel: FTEditProfileViewModel {
    var prefil: String? {
        get {
            return outputGender
        }
    }
    var outputGender: String?
    
    init(title t: String, prefilGender text: String?) {
        outputGender = text
        
        super.init(title: t, type: .gender)
    }
}

class FTDOBViewModel: FTEditProfileViewModel {
    var prefil: String? {
        get {
            return outputDOB
        }
    }
    var outputDOB: String?
    
    init(title t: String, prefilDOB text: String?) {
        outputDOB = text
        
        super.init(title: t, type: .dob)
    }
}

class FTMultipleLinesViewModel: FTEditProfileViewModel {
    var prefil: String? {
        get {
            return outputMultipleLines
        }
    }
    var outputMultipleLines: String?
    
    init(title t: String, prefilMultipleLines text: String?) {
        outputMultipleLines = text
        
        super.init(title: t, type: .multipleLines)
    }
    
    override func cellHeight() -> CGFloat {
        return 160
    }
}

