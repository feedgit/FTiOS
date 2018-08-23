//
//  SignUpResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/23/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

/*
 POST /api/v1/users/account/sign_up/
 HTTP 200 OK
 Allow: POST, OPTIONS
 Content-Type: application/json
 Vary: Accept
 
 {
 "username": "quoc",
 "first_name": "le",
 "last_name": "quoc",
 "email": "quocle@gmail.com",
 "phone_number": 987654321,
 "password": "000000",
 "date_of_birth": "1989-05-05"
 }
 */
class SignUpResponse: Mappable{
    var username: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    var password: String?
    var date_of_birth: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        password <- map["password"]
        date_of_birth <- map["date_of_birth"]
    }
}
