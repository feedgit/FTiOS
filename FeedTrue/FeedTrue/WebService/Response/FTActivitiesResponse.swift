//
//  FTActivitiesResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/25/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit
import ObjectMapper
//"notification_count": 36, // Count unread nofitications
//"message_room_count": 2 // Count unread chat-rooms
class FTActivitiesResponse: Mappable {
    var notification_count: Int = 0
    var message_room_count: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        notification_count <- map["notification_count"]
        message_room_count <- map["message_room_count"]
    }
    
    
}
