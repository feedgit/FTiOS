//
//  String+FeedTrue.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/14/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import SwiftMoment

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func toFTDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    static func somethingBackground() -> String {
        return "#05c8f3"
    }
    
    static func  travelCheckinBackground() -> String {
        return "#ffc65c"
    }
    
    static func foodReviewBackground() -> String {
        return "#ea7878"
    }
}
