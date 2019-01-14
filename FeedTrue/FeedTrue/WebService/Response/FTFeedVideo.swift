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
    var results: [FTFeedVideoContent]?
    
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

class FTFeedVideoContent: Mappable {
    var id = -1
    var uid = ""
    var ct_name = "video"
    var user: UserProfile?
    var thumbnail = ""
    var title = ""
    var duration = ""
    var views = 0
    var timestamp = ""
    var editable = false
    var comments: FTComment?
    var reactions: FTReactions?
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
        title <- map["title"]
        duration <- map["duration"]
        views <- map["views"]
        timestamp <- map["timestamp"]
        editable <- map["editable"]
        comments <- map["comments"]
        reactions <- map["reactions"]
        request_reacted <- map["request_reacted"]
        saved <- map["saved"]
    }
}

