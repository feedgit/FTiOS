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
    
    func validatePhoneNumber(phone: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^((\\+)|(00))[0-9]{6,14}$", options: .caseInsensitive)
            if regex.matches(in: phone, options: [], range: NSMakeRange(0, phone.count)).count > 0 {return true}
        }
        catch {}
        return false
    }
    
    func validateEmail(email: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            if regex.matches(in: email, options: [], range: NSMakeRange(0, email.count)).count > 0 {return true}
        }
        catch {}
        return false
    }
}
