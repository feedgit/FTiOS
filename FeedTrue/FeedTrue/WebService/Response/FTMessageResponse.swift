//
//  FTMessageResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/19/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

class FTMessageResponse: Mappable {
    var next: String?
    var previous: String?
    var page_info: PageInfo?
    var messages: [FTMessage]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        next <- map["next"]
        previous <- map["previous"]
        page_info <- map["page_info"]
        messages <- map["results"]
    }
}

class FTMessage: Mappable {
    var id: Int?
    var user: UserProfile?
    var room: Int?
    var text: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user <- map["user"]
        room <- map["room"]
        text <- map["text"]
    }
    
    
}
