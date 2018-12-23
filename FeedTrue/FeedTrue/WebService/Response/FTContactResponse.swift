//
//  FTContactResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/12/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper
/*
{
    "next": null,
    "previous": null,
    "page_info": {
        "has_next_page": false,
        "next_cursor": null
    },
    "results": [
    {
    "with_user": {
    "id": 1,
    "username": "lecongtoan",
    "full_name": "Lê Công Toàn",
    "first_name": "Công Toàn",
    "last_name": "Lê",
    "avatar": "https://api.feedtrue.com/media/us/1/ava/resized_150x150.jpg"
    },
    "room": {
    "id": 2,
    "name": null,
    "last_message": 1,
    "thumbnail": null
    }
    }
    ]
}
 */
class FTContactResponse: Mappable {
    var next: String?
    var previous: String?
    var page_info: PageInfo?
    var contacts: [FTContact]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        next <- map["next"]
        previous <- map["previous"]
        page_info <- map["page_info"]
        contacts <- map["results"]
    }
}

class FTContact: Mappable {
    var user: UserProfile?
    var room: Room?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user <- map["with_user"]
        room <- map["room"]
    }
    
}

/*
 "room": {
 "id": 2,
 "name": null,
 "last_message": 1,
 "thumbnail": null
 }
 */
class Room: Mappable {
    var id: Int?
    var name: String?
    var last_message: String?
    var thumbnail: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        last_message <- map["last_message"]
        thumbnail <- map["thumbnail"]
    }
    
    
}
