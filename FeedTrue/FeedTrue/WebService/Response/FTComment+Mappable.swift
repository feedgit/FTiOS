//
//  FTComment+Mappable.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/6/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

/*
{
    "id": 41,
    "ct_name": "comment",
    "editable": true,
    "request_reacted": false,
    "user": {
        "id": 21,
        "username": "duongnuhabang",
        "full_name": "Dương Nữ 111 Hạ Băng",
        "first_name": "Dương Nữ 111",
        "last_name": "Hạ Băng",
        "avatar": "https://api.feedtrue.com/media/CACHE/images/avatar/profile/21/avatar/e4673c5d05ff882867ad078f40c59122.jpg"
    },
    "comment": "TEST Comment 222",
    "attachItems": [],
    "posted_on": "2018-10-06T03:32:19.331827Z",
    "reply_count": 0,
    "replies": [],
    "reacts_count": 0
}
 */

class FTCommentMappable: Mappable {
    
    var id: Int?
    var ct_name: String?
    var editable: Bool?
    var request_reacted: Bool?
    var user: UserProfile?
    var comment: String?
    var attachItems: [String]?
    var posted_on: String? // "2018-10-06T03:32:19.331827Z"
    var reply_count: Int?
    var replies: [FTCommentMappable]?
    var reacts_count: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ct_name <- map["ct_name"]
        editable <- map["editable"]
        request_reacted <- map["request_reacted"]
        user <- map["user"]
        comment <- map["comment"]
        attachItems <- map["attachItems"]
        posted_on <- map["posted_on"]
        reply_count <- map["reply_count"]
        replies <- map["replies"]
        reacts_count <- map["reacts_count"]
    }
    

}
