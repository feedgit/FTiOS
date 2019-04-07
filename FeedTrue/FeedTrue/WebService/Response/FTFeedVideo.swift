//
//  FTFeedVideo.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/12/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

class FTFeedVideo: Mappable {
    var count = 0
    var itemOnPage = 0
    var current = 0
    var next = ""
    var previous = ""
    var results: [TagExploreContent]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        itemOnPage <- map["itemOnPage"]
        current <- map["current"]
        next <- map["next"]
        previous <- map["previous"]
        results <- map["results"]
    }
}

class TagExploreContent: Mappable {
    var id = -1
    var uid = ""
    var ct_name = "video"
    var user: UserProfile?
    var thumbnail = ""
    var name = ""
    var duration = ""
    var views = 0
    var timestamp = ""
    var editable = false
    var comments: FTComment?
    var tagged_count = 0
    var request_reacted = ""
    var saved = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        uid <- map["uid"]
        ct_name <- map["ct_name"]
        user <- map["user"]
        thumbnail <- map["thumbnail"]
        name <- map["name"]
        duration <- map["duration"]
        views <- map["views"]
        timestamp <- map["timestamp"]
        editable <- map["editable"]
        comments <- map["comments"]
        tagged_count <- map["tagged_count"]
        request_reacted <- map["request_reacted"]
        saved <- map["saved"]
    }
}

