//
//  FTRegistrationService.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/30/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTRegistrationService: FTCoreServiceComponent {
    func setup() {
        
    }
    
    func reset() {
        _authenticationProfile = nil
    }
    
    private var _authenticationProfile: FTAuthenticationOutput?
    var authenticationProfile: FTAuthenticationOutput? {
        get {
            return _authenticationProfile
        }
    }
    
    func hasAuthenticationProfile() -> Bool {
        return (authenticationProfile != nil) ? true : false
    }
    
    func storeAuthProfile(_ accessToken: String?, profile: UserProfile?) {
        if let token = accessToken {
            // login successful
            _authenticationProfile = FTAuthenticationOutput(accessToken: token, userProfile: profile)
        } else {
            _authenticationProfile = FTAuthenticationOutput(accessToken: "", userProfile: profile)
        }
    }
}

class FTAuthenticationOutput {
    let accessToken: String
    let profile: UserProfile?
    
    init(accessToken token: String, userProfile user: UserProfile?) {
        accessToken = token
        profile = user
    }
}
