//
//  FTAboutReponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/2/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

/*
 {
 "id": 8,
 "username": "duongnuhabang",
 "first_name": "Duong Nu",
 "last_name": "Ha Bang",
 "full_name": "Duong Nu Ha Bang",
 "email": "draftligongquan7@gmail.com",
 "nickname": null,
 "gender": "Female",
 "date_of_birth": "1997-05-22",
 "editable": true,
 "intro": "Đang coi đá banh",
 "fax_number": null,
 "website": null,
 "about": "TEST About",
 "bio": "TEST BIO",
 "quotes": null,
 "interested_in": "MALE",
 "job_title": "Chạy xe ôm",
 "phone_number": "98415212"
 }
 */
class FTAboutReponse: Mappable {
    var id: Int?
    var username: String?
    var first_name: String?
    var last_name: String?
    var full_name: String?
    var email: String?
    var nickname: String?
    var gender: Int?
    var date_of_birth: String? //"1997-05-22",
    var editable: Bool?
    var intro: String?
    var fax_number: String?
    var website: String?
    var about: String?
    var bio: String?
    var quotes: String?
    var interested_in: String?
    var job_title: String?
    var phone_number: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        full_name <- map["full_name"]
        email <- map["email"]
        nickname <- map["nickname"]
        gender <- map["gender"]
        date_of_birth <- map["date_of_birth"]
        editable <- map["editable"]
        intro <- map["intro"]
        fax_number <- map["fax_number"]
        website <- map["website"]
        about <- map["about"]
        bio <- map["bio"]
        quotes <- map["quotes"]
        interested_in <- map["interested_in"]
        job_title <- map["job_title"]
        phone_number <- map["phone_number"]
    }
}
