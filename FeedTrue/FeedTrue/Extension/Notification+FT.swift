//
//  Notification+FT.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/28/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

extension Notification.Name {
    /// Posted when a `Feed tab` is clicked.
    public static let FeedTabTouchAction = Notification.Name(rawValue: "com.toanle.FeedTab.TouchAction")
    
    /// Posted when a `New Feed` is created.
    public static let ComposerPhotoCompleted = Notification.Name(rawValue: "com.toanle.ComposerPhoto.Completed")
}
