//
//  FTUserProfileResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/2/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

class FTUserProfileResponse: Mappable {
    var id: Int?
    var username: String?
    var first_name: String?
    var last_name: String?
    var full_name: String?
    var avatar: String?
    var featured_photos: FTAvatar?
    var editable: Bool?
    var followed_by_viewer: Int?
    var follow_viewer: Bool?
    var relationship_to_user: String?
    var feed_count: Int?
    var photo_video_count: Int?
    var loved: Int?
    var email: String?
    var gender: Int?
    var nickname: String?
    var join_date: String?
    var photostream: [FTPhotoStream]?
    var bio: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        full_name <- map["full_name"]
        avatar <- map["avatar"]
        featured_photos <- map["featured_photos"]
        editable <- map["editable"]
        followed_by_viewer <- map["followed_by_viewer"]
        follow_viewer <- map["follow_viewer"]
        relationship_to_user <- map["relationship_to_user"]
        feed_count <- map["feed_count"]
        photo_video_count <- map["photo_video_count"]
        loved <- map["loved"]
        email <- map["email"]
        gender <- map["gender"]
        nickname <- map["nickname"]
        join_date <- map["join_date"]
        photostream <- map["photostream"]
        bio <- map["bio"]
    }
    
    func isFollowedByViewer() -> Bool {
        guard let isFollow = followed_by_viewer else { return false }
        return isFollow == 1
    }
    
    func isEditable() -> Bool {
        guard let isEditable = editable else { return false }
        return isEditable
    }
}

/*
 "avatar": {
 "type": "photo",
 "data": {
 "id": 112,
 "image": "https://api.feedtrue.com/media/users/21/11_112.gif"
 }
 },
 */

class FTAvatar: Mappable {
    var type: String?
    var data: FTAvatarData?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        data <- map["data"]
    }
    
    
}

class FTAvatarData: Mappable {
    var id: Int?
    var imageURL: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        imageURL <- map["file"]
    }
}

/*
 {
 "id": 22,
 "username": "nguyenduongluuly",
 "full_name": "Nguyễn Dương Lưu Ly",
 "first_name": "Nguyễn Dương",
 "last_name": "Lưu Ly",
 "profile": "authentication",
 "avatar": {
 "type": "photo",
 "data": {
 "id": 77,
 "image": "https://api.feedtrue.com/media/users/22/21_77.jpg"
 }
 }
 }
 ],
 */

/*
 "photostream": [
 {
 "id": 112,
 "image": "https://api.feedtrue.com/media/users/21/11_112.gif",
 "reaction_count": 0,
 "comment_count": 0,
 "date_created": "2018-08-30T04:23:48.485800Z",
 "annotations": []
 },
 */

class  FTPhotoStream: Mappable {
    var id: Int?
    var image: String?
    var reaction_count: Int?
    var comment_count: Int?
    var data_created: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        image <- map["image"]
        reaction_count <- map["reaction_count"]
        comment_count <- map["comment_count"]
        data_created <- map["data_created"]
    }
}
