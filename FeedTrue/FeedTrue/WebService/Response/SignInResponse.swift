//
//  SignInResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/23/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

/*
 {
 "id": 1,
 "profile": "profile",
 "username": "lecongtoan",
 "first_name": "Công Toàn",
 "last_name": "Lê",
 "full_name": "Công Toàn Lê",
 "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImxlY29uZ3RvYW4iLCJ1c2VyX2lkIjoxLCJlbWFpbCI6ImxpZ29uZ3F1YW43QGdtYWlsLmNvbSIsImV4cCI6MjM5OTAxODc4N30.G-JD-1ftjw5SUbqYtrH5WVn9Y3E3HssXUbW1VWjZj4k"
 }

 */
class SignInResponse: Mappable {
    var id: Int?
    var profile: String?
    var username: String?
    var first_name: String?
    var last_name: String?
    var full_name: String?
    var token: String?
    var profilePicURL: ProfilePicURL?
    var notifications: Notifications?
    var contacts: [UserProfile]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        profile <- map["profile"]
        username <- map["username"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        full_name <- map["full_name"]
        token <- map["token"]
        profilePicURL <- map["profile_pic_url"]
        notifications <- map["notifications"]
        contacts <- map["usable_profile"]
    }
    
}

/*
 "profile_pic_url": {
 "id": 19,
 "image": "https://api.feedtrue.com/media/users/1/2_19.jpg",
 "config_translateY": 0,
 "photoset": 2
 },
 */

class ProfilePicURL: Mappable {
    var id: Int?
    var image: String?
    var config_translateY: Int?
    var photoset: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        image <- map["image"]
        config_translateY <- map["config_translateY"]
        photoset <- map["photoset"]
    }
}

/*
 "notifications": {
 "activities": 14,
 "messages": 1,
 "follower_requests": []
 },
 */

class Notifications: Mappable {
    var activities: Int?
    var messages: Int?
    var follower_requests: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        activities <- map["activities"]
        messages <- map["messages"]
        follower_requests <- map["follower_requests"]
    }
}

/*
 "usable_profile": [
 {
 "id": 8,
 "username": "hoi-nuoi-cho-beggie",
 "full_name": " Hội nuôi chó Beggie",
 "first_name": "",
 "last_name": "Hội nuôi chó Beggie",
 "profile": "page",
 "profile_pic_url": null
 },
 {
 "id": 20,
 "username": "hoi-nuoi-heo",
 "full_name": " Hội nuôi heo",
 "first_name": "",
 "last_name": "Hội nuôi heo",
 "profile": "page",
 "profile_pic_url": null
 },
 {
 "id": 25,
 "username": "lich-su-trung-quoc",
 "full_name": " Lịch Sử Trung Quốc",
 "first_name": "",
 "last_name": "Lịch Sử Trung Quốc",
 "profile": "page",
 "profile_pic_url": null
 },
 {
 "id": 1,
 "username": "lecongtoan",
 "full_name": "Công Toàn Lê",
 "first_name": "Công Toàn",
 "last_name": "Lê",
 "profile": "profile",
 "profile_pic_url": {
 "id": 19,
 "image": "https://api.feedtrue.com/media/users/1/2_19.jpg",
 "config_translateY": 0,
 "photoset": 2
 }
 }
 ]
 */

class UserProfile: Mappable {
    var id: Int?
    var profile: String?
    var username: String?
    var first_name: String?
    var last_name: String?
    var full_name: String?
    var profilePicURL: ProfilePicURL?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        profile <- map["profile"]
        username <- map["username"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        full_name <- map["full_name"]
        profilePicURL <- map["profile_pic_url"]
    }

}
