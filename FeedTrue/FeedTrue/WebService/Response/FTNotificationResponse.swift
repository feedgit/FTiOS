//
//  FTNotificationResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

public enum NotificationType: String {
    case react = "react"
    case comment = "comment"
    case reply = "reply"
    case refeed = "refeed"
    case mention = "mention"
    case suggest = "suggest"
    case follow = "follow"
}

class FTNotificationResponse: Mappable {
    var next: String?
    var previous: String?
    var page_info: PageInfo?
    var notifications: [FTNotificationItem]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        next <- map["next"]
        previous <- map["previous"]
        page_info <- map["page_info"]
        notifications <- map["results"]
    }
}

class FTNotificationItem: Mappable {
    var id: Int?
    var from_user: UserProfile?
    var type: String?
    var created_at: String?
    var object: Any?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        from_user <- map["from_user"]
        type <- map["type"]
        created_at <- map["create_at"]
        object <- map["object"]
    }
}

class PageInfo: Mappable {
    var has_next_page: Bool = false
    var next_params: NextParams?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        has_next_page <- map["has_next_page"]
        next_params <- map["next_params"]
    }
}

class NextParams: Mappable {
    var content_type: Int?
    var limit: String?
    var object_id: Int?
    var offset: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        content_type <- map["content_type"]
        limit <- map["limit"]
        object_id <- map["object_id"]
        offset <- map["offset"]
    }
}


