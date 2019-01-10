//
//  FTArticles.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/19/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

class FTArticles: Mappable {
    var count = 0
    var next = ""
    var previous = ""
    var results: [FTArticleContent]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        next <- map["next"]
        previous <- map["previous"]
        results <- map["results"]
    }
}

class FTArticleContent: Mappable {
    var id = -1
    var ct_name = ""
    var uid: String?
    var title = ""
    var description = ""
    var thumbnail = ""
    var slug = ""
    var user: UserProfile?
    var create_date = ""
    var editable = false
    var comments: FTComment?
    var reactions: FTReactions?
    var request_reacted = ""
    var saved = false
    var created_at: String?
    var updated_at: String?
    var content: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ct_name <- map["ct_name"]
        uid <- map["uid"]
        user <- map["user"]
        thumbnail <- map["thumbnail"]
        title <- map["title"]
        description <- map["description"]
        slug <- map["slug"]
        create_date <- map["create_date"]
        editable <- map["editable"]
        comments <- map["comments"]
        reactions <- map["reactions"]
        request_reacted <- map["request_reacted"]
        saved <- map["saved"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        content <- map["content"]
    }
}
