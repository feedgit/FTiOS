//
//  FTFeedResponse.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/11/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import ObjectMapper

class FTFeedResponse: Mappable {
    var count: Int?
    var next: String?
    var previous: String?
    var feeds: [FTFeedInfo]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        next <- map["next"]
        previous <- map["previous"]
        feeds <- map["results"]
    }
}

/*
 "id": 44,
 "ct_name": "feed",
 "editable": false,
 "write_to": null,
 "privacy": "PUBLIC",
 "self_liked": "LOVE",
 "user": {
 "id": 22,
 "username": "nguyenduongluuly",
 "full_name": "Nguyễn Dương Lưu Ly",
 "first_name": "Nguyễn Dương",
 "last_name": "Lưu Ly",
 "profile": "profile",
 "avatar": {
 "type": "photo",
 "data": {
 "id": 77,
 "file": "https://api.feedtrue.com/media/users/22/21_77.jpg"
 }
 },
 "intro": ""
 },
 "date": "2018-08-09T07:18:15.248000Z",
 */
class FTFeedInfo: Mappable {
    var id: Int?
    var ct_name: String?
    var editable: Bool?
    var write_to: String?
    var privacy: Int?
    var self_liked: String?
    var user: UserProfile?
    var request_reacted: String?
    var date: String?
    var feedcontent: [FTFeedContent]?
    var display: Int?
    var text: String?
    var feed_type: Int?
    var reactions: FTReactions?
    var comment: FTComment?
    var feeling: String?
    var hashtag: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ct_name <- map["ct_name"]
        editable <- map["editable"]
        write_to <- map["write_to"]
        privacy <- map["privacy"]
        self_liked <- map["self_liked"]
        user <- map["user"]
        request_reacted <- map["request_reacted"]
        date <- map["date"]
        feedcontent <- map["feedcontent"]
        display <- map["display"]
        text <- map["text"]
        feed_type <- map["feed_type"]
        reactions <- map["reactions"]
        comment <- map["comments"]
        feeling <- map["feeling"]
        hashtag <- map["hashtag"]
    }
}

/*
"feedcontent": {
    "display_type": 1,
    "data": [
    {
    "id": 108,
    "image": "https://api.feedtrue.com/media/users/1/9_108.jpg"
    },
    {
    "id": 103,
    "image": "https://api.feedtrue.com/media/users/1/9_103.jpg"
    },
    {
    "id": 59,
    "image": "https://api.feedtrue.com/media/users/1/9_59.jpg"
    }
    ]
},
"feedcontent": {
    "display_type": 2,
    "data": [
    {
    "id": 11,
    "featured_image": "https://api.feedtrue.com/media/users/21/video/11/artwork.jpg",
    "file": "https://api.feedtrue.com/media/users/21/video/11/11.mp4"
    }
    ]
},
 
"feedcontent": {
    "display_type": 3,
    "data": [
    {
    "id": 67,
    "title": "Gác xếp của tôi",
    "thumbnail": "https://api.feedtrue.com/media/avatar/article/67.gif",
    "slug": "gac-xep-cua-toi"
    }
    ]
},

"feedcontent": {
    "display_type": 4,
    "data": [
    {
    "id": 56,
    "user": {
    "id": 1,
    "username": "lecongtoan",
    "full_name": "Công Toàn Lê",
    "first_name": "Công Toàn",
    "last_name": "Lê",
    "avatar": "https://api.feedtrue.com/media/avatar/profile/1/avatar.jpg"
    },
    "date": "2018-09-18T07:03:28.041000Z",
    "feedcontent": {
    "display_type": 1,
    "data": [
    {
    "id": 108,
    "image": "https://api.feedtrue.com/media/users/1/9_108.jpg"
    },
    {
    "id": 103,
    "image": "https://api.feedtrue.com/media/users/1/9_103.jpg"
    },
    {
    "id": 59,
    "image": "https://api.feedtrue.com/media/users/1/9_59.jpg"
    }
    ]
    },
    "text": "Việt Nam (tên chính thức: Cộng hòa Xã hội Chủ nghĩa Việt Nam) là quốc gia nằm ở phía Đông bán đảo Đông Dương thuộc khu vực Đông Nam Á. Với dân số ước tính 96,5 triệu dân vào năm 2018, Việt Nam là quốc gia đông dân thứ 15 trên thế giới và là quốc gia đông dân thứ 8 của châu Á. Thủ đô là thành phố Hà Nội kể từ năm 1976, với Thành phố Hồ Chí Minh là thành phố đông dân nhất."
    }
    ]
},
*/
 
 
class FTFeedContent: Mappable {
    var display_type: Int?
    var data: [String: Any]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        display_type <- map["display_type"]
        data <- map["data"]
    }
}

class FTReactions: Mappable {
    //var type: String?
    var count: Int?
    var data: Any?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        //type <- map["type"]
        count <- map["count"]
        data <- map["data"]
    }
}

class FTComment: Mappable {
    
    var count: Int?
    var data: [FTCommentData]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        data <- map["data"]
    }
}

class FTCommentData: Mappable {
    var id: Int?
    var ct_name: String?
    var editable: Bool?
    var self_liked: Bool?
    var user: UserProfile?
    var comment: String?
    var attachItems: [String]?
    var posted_on: String?
    var reply_count: Int?
    var replies: [Any]?
    var reacts_count: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ct_name <- map["ct_name"]
        editable <- map["editable"]
        self_liked <- map["self_liked"]
        user <- map["user"]
        comment <- map["comment"]
        attachItems <- map["attachItems"]
        posted_on <- map["posted_on"]
        reply_count <- map["reply_count"]
        replies <- map["replies"]
        reacts_count <- map["reacts_count"]
    }
}
