//
//  FTCoreService.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/30/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
protocol FTCoreServiceComponent {
    func setup()
}

class FTCoreService: NSObject, FTCoreServiceComponent {
    private(set) var webService: WebService?
    private(set) var registrationService: FTRegistrationService?
    private(set) var keychainService: FTKeyChainService?
    
    static let share: FTCoreService = FTCoreService()
    
    func setup() {
        webService = WebService.share
        registrationService = FTRegistrationService.share
        keychainService = FTKeyChainService.shared
    }
    
    private var _hasAuthInKeychain: Bool = false
    var hasAuthInKeychain: Bool { get { return _hasAuthInKeychain } }
    
    func isLogged() -> Bool {
        return registrationService!.hasAuthenticationProfile()
    }
    
    func start() {
        
    }
}
