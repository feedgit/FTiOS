//
//  Date+FT.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/3/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

extension Date {
    
    func dobString() -> String {
        let noTimeDate = Calendar.current.startOfDay(for: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dobString = dateFormatter.string(from: noTimeDate)
        
        return dobString
    }
    
    func dobAPIString() -> String {
        let noTimeDate = Calendar.current.startOfDay(for: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dobAPIString = dateFormatter.string(from: noTimeDate)
        
        return dobAPIString
    }
}
