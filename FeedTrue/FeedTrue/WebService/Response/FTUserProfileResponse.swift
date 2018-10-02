//
//  FTUserProfileResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/2/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

enum FollowsViewerType: Int {
    case following = 0
    case secret_following = 1
    case follow_back = 2
}

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
    var follows_viewer: Int?
    var relationship_to_user: String?
    var feed_count: Int?
    var photo_video_count: Int?
    var friends_count: Int?
    var loved: Int?
    var friends_intro: [FTFriendInfos]?
    var email: String?
    var gender: Int?
    var nickname: String?
    var join_date: String?
    var photostream: [FTPhotoStream]?
    var intro: String?
    
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
        follows_viewer <- map["follows_viewer"]
        relationship_to_user <- map["relationship_to_user"]
        feed_count <- map["feed_count"]
        photo_video_count <- map["photo_video_count"]
        friends_count <- map["friends_count"]
        loved <- map["loved"]
        friends_intro <- map["friends_intro"]
        email <- map["email"]
        gender <- map["gender"]
        nickname <- map["nickname"]
        join_date <- map["join_date"]
        photostream <- map["photostream"]
        intro <- map["intro"]
    }
    
    func getFollowType() -> FollowsViewerType {
        if let follow = follows_viewer {
            return FollowsViewerType.init(rawValue: follow) ?? .secret_following
        }
        return .secret_following
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

class FTFriendInfos: Mappable {
    var id: Int?
    var username: String?
    var first_name: String?
    var last_name: String?
    var full_name: String?
    var profile: String?
    var avatar: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        full_name <- map["full_name"]
        avatar <- map["avatar"]
        profile <- map["profile"]
    }
}

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
    var annotations: [FTAnnotation]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        image <- map["image"]
        reaction_count <- map["reaction_count"]
        comment_count <- map["comment_count"]
        data_created <- map["data_created"]
        annotations <- map["annotations"]
    }
}

/*
 "annotations": [
 {
 "id": 21,
 "user": {
 "id": 1,
 "username": "lecongtoan",
 "full_name": "Công Toàn Lê",
 "first_name": "Công Toàn",
 "last_name": "Lê",
 "profile": "authentication",
 "avatar": {
 "type": "photo",
 "data": {
 "id": 110,
 "image": "https://api.feedtrue.com/media/users/1/9_110.jpg"
 }
 }
 },
 "data": {
 "id": 9,
 "tag": "caythongcodon"
 },
 "tag_type": "hashtag",
 "display_type": 5,
 "x": "0.6656829428",
 "y": "0.1471114291",
 "editable": false
 }
 ]
 },
 */

class FTAnnotation: FTFriendInfos {
    var dataInfo: FTFriendInfos?
    var tag_type: String?
    var display_type: Int?
    var x: String?
    var y: String?
    var editable: Bool?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        dataInfo <- map["data"]
        tag_type <- map["tag_type"]
        display_type <- map["display_type"]
        x <- map["x"]
        y <- map["y"]
        editable <- map["editable"]
    }
}
