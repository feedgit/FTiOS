//
//  FTLocationResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/26/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

class FTLocationResponse: Mappable {
    var next: String?
    var count: Int = 0
    var page_info: PageInfo?
    var results: [FTLocationData] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        next <- map["next"]
        count <- map["count"]
        page_info <- map["page_info"]
        results <- map["results"]
    }
    

}

class FTLocationData: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        thumbnail <- map["thumbnail"]
        category <- map["category"]
        address <- map["address"]
        description <- map["description"]
        long <- map["long"]
        lat <- map["lat"]
        checkin_count <- map["checkin_count"]
    }
    
    var id: Int = 0
    var name: String = ""
    var thumbnail: String = ""
    var category: String = ""
    var address: String = ""
    var description: String = ""
    var long: Double = 0
    var lat: Double = 0
    var checkin_count: Int = 0
}
