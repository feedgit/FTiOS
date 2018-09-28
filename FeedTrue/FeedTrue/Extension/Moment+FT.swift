//
//  Moment+FT.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/28/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import SwiftMoment

extension Moment {
    public func fromNowFT() -> String {
        var dateString = fromNow()
        
        if dateString.contains(" seconds ago") {
            dateString = dateString.replacingOccurrences(of: "seconds ago", with: "s")
        }
        
        if dateString.contains("A minute") {
            dateString = dateString.replacingOccurrences(of: "A minute", with: "1m")
        }
        
        if dateString.contains("minutes ago") {
            dateString = dateString.replacingOccurrences(of: " minutes ago", with: "m")
        }
        
        if dateString.contains("An hour") {
            dateString = dateString.replacingOccurrences(of: "An hour", with: "1h")
        }
        
        if dateString.contains(" hours ago") {
            dateString = dateString.replacingOccurrences(of: " hours ago", with: "h")
        }
        
        if dateString.contains(" days ago") {
            dateString = dateString.replacingOccurrences(of: " days ago", with: "d")
        }
        
        if dateString.contains(" weeks ago") {
            dateString = dateString.replacingOccurrences(of: " weeks ago", with: "w")
        }
        
        if dateString.contains(" months ago") {
            dateString = dateString.replacingOccurrences(of: " months ago", with: "m")
        }
        
        if dateString.contains(" years ago") {
            dateString = dateString.replacingOccurrences(of: " years ago", with: "y")
        }
        
        if dateString.contains("Yesterday") {
            dateString = dateString.replacingOccurrences(of: "Yesterday", with: "1d")
        }
        
        if dateString.contains("Last week") {
            dateString = dateString.replacingOccurrences(of: "Last week", with: "7d+")
        }
        
        if dateString.contains("Last month") {
            dateString = dateString.replacingOccurrences(of: "Last month", with: "30d+")
        }
        
        if dateString.contains("Just now") {
            dateString = dateString.replacingOccurrences(of: "Just now", with: "now")
        }
        
        // TODO: handler some cases
        /*
         if deltaSeconds < 5 {
         // Just Now
         return NSDateTimeAgoLocalizedStrings("Just now")
         
         }
         
         else if deltaSeconds < (yearInSeconds * 2) {
         // Last Year
         return NSDateTimeAgoLocalizedStrings("Last year")
         }
         */
        return dateString
    }
}

