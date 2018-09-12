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

/*
 "id": 44,
 "ct_name": "feed",
 "editable": false,
 "write_to": null,
 "privacy": "PUBLIC",
 "self_liked": "LOVE",
 "user": {
 "id": 22,
 "username": "nguyenduongluuly",
 "full_name": "Nguyễn Dương Lưu Ly",
 "first_name": "Nguyễn Dương",
 "last_name": "Lưu Ly",
 "profile": "profile",
 "avatar": {
 "type": "photo",
 "data": {
 "id": 77,
 "file": "https://api.feedtrue.com/media/users/22/21_77.jpg"
 }
 },
 "intro": ""
 },
 "date": "2018-08-09T07:18:15.248000Z",
 */
class FTFeedInfo: Mappable {
    var id: Int?
    var ct_name: String?
    var editable: Bool?
    var write_to: String?
    var privacy: Int?
    var self_liked: String?
    var user: UserProfile?
    var request_reacted: String?
    var date: String?
    var feedcontent: [FTFeedContent]?
    var display: Int?
    var text: String?
    var feed_type: Int?
    var reactions: FTReactions?
    var comment: FTComment?
    var feeling: String?
    var hashtag: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ct_name <- map["ct_name"]
        editable <- map["editable"]
        write_to <- map["write_to"]
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
        comment <- map["comments"]
        feeling <- map["feeling"]
        hashtag <- map["hashtag"]
    }
}

class FTFeedContent: Mappable {
    var id: Int?
    var type: String?
    var order_num: Int?
    var data: Any?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        order_num <- map["order_num"]
        data <- map["data"]
    }
}

class FTReactions: Mappable {
    //var type: String?
    var count: Int?
    var data: Any?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        //type <- map["type"]
        count <- map["count"]
        data <- map["data"]
    }
}

class FTComment: Mappable {
    
    var count: Int?
    var data: [FTCommentData]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        data <- map["data"]
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
