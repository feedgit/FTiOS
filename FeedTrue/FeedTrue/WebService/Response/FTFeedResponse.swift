//
//  FTFeedResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

class FTFeedResponse: Mappable {
    var count: Int?
    var next: String?
    var previous: String?
    var feeds: [FTFeedInfo]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        next <- map["next"]
        previous <- map["previous"]
        feeds <- map["results"]
    }
}

class FTFeedInfo: Mappable {
    var id: Int?
    var uid: String?
    var ct_name: String?
    var editable: Bool?
    var views: Int?
    var privacy: Int?
    var self_liked: String?
    var user: UserProfile?
    var request_reacted: String?
    var date: String?
    var feedcontent: FTFeedContent?
    var display: Int?
    var text: String?
    var feed_type: Int?
    var reactions: FTReactions?
    var loves: Int?
    var comment: FTComment?
    var feeling: String?
    var hashtag: [String]?
    var saved: Bool?
    var location: FTLocation?
    
    required init?(map: Map) {
        views = 1000
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        uid <- map["uid"]
        ct_name <- map["ct_name"]
        editable <- map["editable"]
        views <- map["views"]
        privacy <- map["privacy"]
        self_liked <- map["self_liked"]
        user <- map["user"]
        request_reacted <- map["request_reacted"]
        date <- map["date"]
        feedcontent <- map["feedcontent"]
        display <- map["display"]
        text <- map["text"]
        feed_type <- map["feed_type"]
        reactions <- map["reactions"]
        loves <- map ["loves"]
        comment <- map["comments"]
        feeling <- map["feeling"]
        hashtag <- map["hashtag"]
        saved <- map["saved"]
        location <- map["location"]
    }
}
 
class FTFeedContent: Mappable {
    var type: String?
    var data: [[String: Any]]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        data <- map["data"]
    }
}

/*
 "data": [
 {
 "user": {
 "id": 21,
 "full_name": "Dương Nữ Hạ Băng",
 "avatar": "https://api.feedtrue.com/media/CACHE/images/avatar/profile/21/avatar/e4673c5d05ff882867ad078f40c59122.jpg"
 },
 "react_type": "LOVE"
 },
 {
 "user": {
 "id": 1,
 "full_name": "Công Toàn Lê",
 "avatar": "https://api.feedtrue.com/media/CACHE/images/avatar/profile/1/avatar/2d93ff2414a22888af288b3160ac6c8f.jpg"
 },
 "react_type": "LOVE"
 }
 ]
 */
class FTReactions: Mappable {
    var next: String?
    var count: Int?
    var pageInfo: PageInfo?
    var data: [FTReactData]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        next <- map["next"]
        count <- map["count"]
        pageInfo <- map["page_info"]
        data <- map["results"]
    }
}

/*
 "user": {
 "id": 1,
 "full_name": "Công Toàn Lê",
 "avatar": "https://api.feedtrue.com/media/CACHE/images/avatar/profile/1/avatar/2d93ff2414a22888af288b3160ac6c8f.jpg"
 },
 "react_type": "LOVE"
 */
class FTReactData: Mappable {
    var user: UserProfile?
    var react_type: String?
    var timestamp: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user <- map["user"]
        react_type <- map["react_type"]
        timestamp <- map["timestamp"]
    }
}

/*
 {
 "id": 1,
 "full_name": "Công Toàn Lê",
 "avatar": "https://api.feedtrue.com/media/CACHE/images/avatar/profile/1/avatar/2d93ff2414a22888af288b3160ac6c8f.jpg"
 }
 */
class FTReactUser: Mappable {
    var id: Int = -1
    var full_name = ""
    var avatar = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        full_name <- map["full_name"]
        avatar <- map["avatar"]
    }
    
    
}

class FTComment: Mappable {
    var next: String?
    var count: Int?
    var pageInfo: PageInfo?
    var comments: [FTCommentMappable]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        next <- map["next"]
        count <- map["count"]
        pageInfo <- map["page_info"]
        comments <- map["results"]
    }
}

class FTCommentData: Mappable {
    var id: Int?
    var ct_name: String?
    var editable: Bool?
    var self_liked: Bool?
    var user: UserProfile?
    var comment: String?
    var attachItems: [String]?
    var posted_on: String?
    var reply_count: Int?
    var replies: [Any]?
    var reacts_count: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ct_name <- map["ct_name"]
        editable <- map["editable"]
        self_liked <- map["self_liked"]
        user <- map["user"]
        comment <- map["comment"]
        attachItems <- map["attachItems"]
        posted_on <- map["posted_on"]
        reply_count <- map["reply_count"]
        replies <- map["replies"]
        reacts_count <- map["reacts_count"]
    }
}

class FTLocation: Mappable {
    
    var id: Int?
    var name: String?
    var thumbnail: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        thumbnail <- map["thumbnail"]
    }
}
