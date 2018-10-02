//
//  FTEditUserResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

/*
 {
 "username": "duongnuhabang",
 "email": "draftligongquan7@gmail.com",
 "first_name": "Duong Nu",
 "last_name": "Ha Bang",
 "nickname": null,
 "gender": "Female",
 "date_of_birth": "1997-05-22",
 "job_title": "Chạy xe ôm",
 "phone_number": "98415212",
 "intro": "Đang coi đá banh",
 "interested_in": "MALE",
 "fax_number": null,
 "quotes": null,
 "bio": "TEST BIO",
 "website": null,
 "about": "TEST About"
 }
 */
class FTEditUserResponse: Mappable {
    var username: String?
    var email: String?
    var first_name: String?
    var last_name: String?
    var nickname: String?
    var gender: Int?
    var date_of_birth: String?
    var job_title: String?
    var phone_number: String?
    var intro: String?
    var interested_in: String?
    var fax_number: String?
    var quotes: String?
    var bio: String?
    var website: String?
    var about: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        email <- map["email"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        nickname <- map["nickname"]
        gender <- map["gender"]
        date_of_birth <- map["date_of_birth"]
        job_title <- map["job_title"]
        phone_number <- map["phone_number"]
        intro <- map["intro"]
        interested_in <- map["interested_in"]
        fax_number <- map["fax_number"]
        quotes <- map["quotes"]
        bio <- map["bio"]
        website <- map["website"]
        about <- map["about"]
    }
}
