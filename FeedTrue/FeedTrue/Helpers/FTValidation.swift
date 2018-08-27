//
//  FTValidation.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/27/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

struct FTValidation {
    func validateUsername(str: String) -> Bool
    {
        do
        {
            let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z\\_]{6,18}$", options: .caseInsensitive)
            if regex.matches(in: str, options: [], range: NSMakeRange(0, str.count)).count > 0 {return true}
        }
        catch {}
        return false
    }
}
