//
//  FTCommentReplies.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/10/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

class FTCommentReplies: Mappable {
    var count: Int = 0
    var next: String = ""
    var previous: String = ""
    var results: [FTCommentMappable] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        next <- map["next"]
        previous <- map["previous"]
        results <- map["results"]
    }
}
