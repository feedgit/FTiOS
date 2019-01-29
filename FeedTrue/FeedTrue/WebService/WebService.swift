//
//  WebService.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/23/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftMoment
import SwiftyJSON

class WebService: NSObject, FTCoreServiceComponent {
    
    static let share: WebService = WebService()
    let host = "https://api.feedtrue.com"
    
    func setup() {
        
    }
    
    func getToken() -> String? {
        return FTKeyChainService.shared.accessToken()
    }
    
    func showLogin() {
        NotificationCenter.default.post(name: .ShowLogin, object: nil)
    }
    
    func signIn(username: String, password: String, completion: @escaping (Bool, SignInResponse?)->()) {
        let params:[String: Any] = [
            "username": username,
            "password": password
        ]
        
        let urlString = "\(host)/api/v1/auth/login/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseObject { (response: DataResponse<SignInResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }


                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                if value.token == nil || value.user == nil {
                    completion(false, nil)
                } else {
                    completion(true, value)
                }
        }

//        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
//            .responseJSON { (response) in
//                print(response.debugDescription)
//                completion(false, nil)
//        }
        
    }
    
    func validateSignUp(info: SignUpInfo, completion: @escaping (Bool, [String: Any]?)->()) {
        let params:[String: Any] = [
            "username": info.username ?? "",
            "first_name": info.first_name ?? "",
            "last_name": info.last_name ?? "",
            "email": info.email ?? "",
            "phone_number": info.phone_number ?? "",
            "password": info.password ?? "",
            //"date_of_birth": null
        ]
        
//        // TEST
//        info.date_of_birth = "1989-20-05"
//
//        if let date = info.date_of_birth {
//            params["date_of_birth"] = date
//        }
        
        let urlString = "\(host)/api/v1/auth/registration/attempt/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    completion(false, nil)
                    return
                }
                
                if let _ = value["success"] as? String {
                    completion(true, value)
                    return
                }
                
                completion(false, value)
        }
    }
    
    func validateUsername(username: String, completion: @escaping (Bool, String?)->()) {
        let params = [
            "username": username
        ]
        
        let urlString = "\(host)/api/v1/auth/registration/attempt/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    completion(false, nil)
                    return
                }
                
                if let msg = value["message"] as? String {
                    completion(true, msg)
                    return
                }
                
                if let errorMsg = value["error"] as? String {
                    completion(false, errorMsg)
                    return
                }
        }
    }
    
    func validatePhone(phone: String, email: String, completion: @escaping (Bool, [String: Any]?)->()) {
        let params = [
            "phone_number": phone,
            "email": email
        ]
        
        let urlString = "\(host)/api/v1/auth/registration/attempt/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    completion(false, nil)
                    return
                }
                
                if let _ = value["message"] as? String {
                    completion(true, value)
                    return
                }
                
                completion(false, value)
        }
    }
    
    func signUp(info: SignUpInfo, completion: @escaping (Bool, SignUpResponse?)->()) {
        let params:[String: Any] = [
            "username": info.username ?? "",
            "first_name": info.first_name ?? "",
            "last_name": info.last_name ?? "",
            "email": info.email ?? "",
            "phone_number": info.phone_number ?? "",
            "password": info.password ?? "",
            "gender": info.gender ?? "Female"
            //"date_of_birth": null
        ]
        let urlString = "\(host)/api/v1/auth/registration/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseObject { (response: DataResponse<SignUpResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func signInWithFacebook(token: String, completion: @escaping (Bool, SignInResponse?)->()) {
        let params:[String: Any] = [
            "access_token": "\(token)"
        ]
        let urlString = "\(host)/api/v1/auth/login/facebook/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseObject { (response: DataResponse<SignInResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                if value.token == nil || value.user == nil {
                    completion(false, nil)
                } else {
                    completion(true, value)
                }
        }
    }
    
    func logOut(token: String, completion: @escaping (Bool, String?)->()) {
        let params:[String: Any] = [
            "access_token": "\(token)"
        ]
        let urlString = "\(host)/api/v1/auth/logout/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    completion(false, nil)
                    return
                }
                
                if let detailMessage = value["detail"] as? String {
                    completion(true, detailMessage)
                    return
                }
                
                completion(false, nil)
        }
    }
    
    func getUserInfo(username: String, completion: @escaping (Bool, FTUserProfileResponse?)->()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/users/\(username)/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTUserProfileResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func getUserAbout(username: String, completion: @escaping (Bool, FTAboutReponse?)->()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }

        let urlString = "\(host)/api/v1/users/\(username)/about/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTAboutReponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func editUserInfo(token: String, editInfo: FTEditUserInfo, completion: @escaping (Bool, FTEditUserResponse?)->()) {
        
        let params:[String: Any] = [
            "first_name": editInfo.fistname ?? "",
            "last_name": editInfo.lastname ?? "",
            "nickname": editInfo.nickname ?? "",
            "gender": editInfo.gender ?? "",
            "intro": editInfo.intro ?? "",
            "about": editInfo.about ?? "",
            "date_of_birth": editInfo.dob ?? "",
            "bio": editInfo.bio ?? "",
            "quotes": editInfo.quotes ?? "",
            "email": editInfo.email ?? "",
            "website": editInfo.website ?? ""
        ]
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/users/account/edit/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .patch, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTEditUserResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                if let username = value.username, !username.isEmpty {
                    completion(true, value)
                } else {
                    completion(false, nil)
                }
                
        }
    }
    
    func getFeed(limit: Int?, offset: Int?, username: String?, ordering: String? = nil, completion: @escaping (Bool, FTFeedResponse?) -> ()) {
        // https://api.feedtrue.com/api/v1/f/?page=1&per_page=1
        let params:[String: Any] = [
            "limit": limit ?? 5,
            "offset" : offset ?? 0,
            "ordering" : ordering ?? HotFeedType.following.rawValue
        ]
        
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/feed/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTFeedResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func loadMoreFeed(nextURL: String, token: String, completion: @escaping (Bool, FTFeedResponse?) -> ()) {
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = nextURL
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTFeedResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func deleteFeed(feedID: String, completion: @escaping (Bool, Any?) -> ()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/f/\(feedID)/delete/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    // MARK: - Follow APIs
    /*
     Follow
     
     POST /api/v1/users/${username}/follow/
     
     Secret Follow
     
     POST /api/v1/users/${username}/secret_follow/
     
     UnFollow
     
     POST /api/v1/users/${username}/unfollow/
     */
    
    func follow(username: String, completion: @escaping (Bool, String?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/users/\(username)/follow/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    completion(false, nil)
                    return
                }
                if let relationship = value["relationship"] as? Int {
                    completion(relationship == 0, nil)
                    return
                }
                completion(false, nil)
        }
    }
    
    func secretFollow(username: String, completion: @escaping (Bool, String?)->()) {
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/users/\(username)/secret_follow/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    completion(false, nil)
                    return
                }
                if let relationship = value["relationship"] as? Int {
                    completion(relationship == 1, nil)
                    return
                }
                completion(false, nil)
        }
        
    }
    
    func unfollow(username: String, completion: @escaping (Bool, String?)->()) {
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/users/\(username)/unfollow/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: String] else {
                    completion(false, nil)
                    return
                }
                if let msg = value["message"] {
                    completion(true, msg)
                    return
                } else if let error_msg = value["error"] {
                    completion(false, error_msg)
                    return
                }
                completion(false, nil)
        }
    }
    
    /*
     Send a react to server (React & Change React)
     
     POST /react/
     
     Demo Data transmit: { content_type: {ct_name}, object_id: {ct_id}, react_type: {react_type} }
     
     Example: If you want to react LOVE with video 44, transmit: { content_type: 'video', object_id: 6, react_type: 'LOVE' }
     */
    func react(ct_name: String, ct_id: Int, react_type: String, completion: @escaping (Bool, String?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        let params:[String: Any] = [
            "content_type": ct_name,
            "object_id" : ct_id,
            "react_type": react_type
        ]
        
        let urlString = "\(host)/api/v1/react/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    completion(false, nil)
                    return
                }
                if let react_type = value["react_type"] as? String {
                    completion(true, react_type)
                    return
                }
                completion(false, nil)
        }
    }
    /*
     Remove a react (Un-React)
     
     POST /react/dis/
     
     Demo data tranmit: { content_type: {ct_name}, object_id: {ct_id} }
     */
    func removeReact(ct_name: String, ct_id: Int, completion: @escaping (Bool, String?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let params:[String: Any] = [
            "content_type": ct_name,
            "object_id" : ct_id
        ]
        
        let urlString = "\(host)/api/v1/react/dis/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
            .response { (response) in
                guard response.response?.statusCode == 200 else {
                    completion(false, nil)
                    return
                }
                
                completion(true, nil)
        }
    }
    
    /*
     Save
     
     POST /api/v1/saved/<ct_name>/<ct_id>/
     
     Example: If you save feed with ID = 98, POST /api/v1/saved/feed/98/
     */
    func saveFeed(ct_name: String, ct_id: Int, completion: @escaping (Bool, String?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/saved/\(ct_name)/\(ct_id)/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: String] else {
                    completion(false, nil)
                    return
                }
                if let msg = value["message"] {
                    completion(true, msg)
                    return
                } else if let error_msg = value["error"] {
                    completion(false, error_msg)
                    return
                }
                completion(false, nil)
        }
    }
    
    /*
     Remove a Saved
     
     POST /api/v1/saved/<ct_name>/<ct_id>/unsave/
     */
    
    func removeSaveFeed(ct_name: String, ct_id: Int, completion: @escaping (Bool, String?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/saved/\(ct_name)/\(ct_id)/unsave/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: String] else {
                    completion(false, nil)
                    return
                }
                if let msg = value["message"] {
                    completion(true, msg)
                    return
                } else if let error_msg = value["error"] {
                    completion(false, error_msg)
                    return
                }
                completion(false, nil)
        }
    }
    
    func sendComment(ct_name: String, ct_id: Int, comment: String, parentID: Int?, completion: @escaping (Bool, FTCommentMappable?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        var params:[String: Any] = [
            "content_type": ct_name,
            "object_id" : ct_id,
            "comment": comment
        ]
        
        if let parent = parentID {
            params = [
            "content_type": ct_name,
            "object_id" : ct_id,
            "comment": comment,
            "parent": parent
            ]
        }
        
        let urlString = "\(host)/api/v1/comments/create/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTCommentMappable>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                if value.comment == comment {
                    completion(true, value)
                    return
                }
                
                completion(true, value)
        }
    }
    
    
    func deleteComment(ct_id: Int, completion: @escaping (Bool, String?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        let urlString = "\(host)/api/v1/comments/\(ct_id)/delete/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                guard let value = response.result.value as? [String: String] else {
                    completion(false, nil)
                    return
                }
                if let msg = value["message"] {
                    completion(true, msg)
                    return
                } else if let error_msg = value["error"] {
                    completion(false, error_msg)
                    return
                }
                completion(false, nil)
        }
    }
    
    func editComment(ct_id: Int, comment: String, parentID: Int?, completion: @escaping (Bool, FTCommentMappable?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/comments/\(ct_id)/edit/"
        
        let params:[String: Any] = [
            "comment": comment
        ]
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .patch, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTCommentMappable>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                if value.comment == comment {
                    completion(true, value)
                    return
                }
                
                completion(false, value)
        }
    }
    
    //https://api.feedtrue.com/api/v1/comments/feed/102/
    
    func getComments(ct_id: Int, completion: @escaping (Bool, FTCommentReplies?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/comments/feed/\(ct_id)/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTCommentReplies>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                if value.count > 0 {
                    completion(true, value)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func getMoreComments(nextString: String, completion: @escaping (Bool, FTCommentReplies?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        guard let url = URL(string: nextString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTCommentReplies>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                if value.count > 0 {
                    completion(true, value)
                    return
                }
                
                completion(false, value)
        }
    }
    
    func uploadAvatar(image: UIImage, completion: @escaping (Bool, String?) -> ()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(false, nil)
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)",
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"
        ]
        
        let _: [String: Any] = [
            "file": imageData//,
            //"filename": "\(moment().description).jpg"
        ]
        
        let urlString = "\(host)/api/v1/users/account/upload_avatar/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        let fileName = "\(Date().dateTimeString()).png"
        Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: "file", fileName: fileName, mimeType: "image/png")
        }, to: url, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress.debugDescription)
                })
                
                upload.responseJSON { response in
                    //print response.result
                    print(response.result.debugDescription)
                    guard let value = response.result.value as? [String: Any] else {
                        completion(false, nil)
                        return
                    }
                    
                    guard let success = value["success"] as? Int else {
                        completion(false, nil)
                        return
                    }
                    
                    let avatar = value["avatar"] as? String

                    completion(success == 1, avatar)
                }
                
            case .failure(let encodingError):
                //print encodingError.description
                print(encodingError.localizedDescription)
                completion(false, nil)
            }
        }
    }
    
    func getFeedVideo(username: String?, completion: @escaping (Bool, FTFeedVideo?) -> ()) {
        
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/media/video/feed/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTFeedVideo>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func getArticles(username: String?, completion: @escaping (Bool, FTArticles?) -> ()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/blog/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTArticles>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func loadMoreArticles(nextURL: String, completion: @escaping (Bool, FTArticles?) -> ()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = nextURL
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTArticles>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    /*
         POST /composer/photo/
     
         Type: MultiPart FormData
         Request data:
     
         image_files: [<Image File>, <Image File>, <Image File>]: Array of uploaded images, limit 10.
         image_data: [{ id: <filename_with_extension_1>, caption: <caption_text1> }, { id: <filename_with_extension_2>, caption: <caption_text2> }]: Json type
         privacy: 0, 1 or 2 - View Privacy API Documentation - required
         feed.text: 'Example Text' - No required Have key if active PostFeed
         Response:
     
         If have PostInFeed, response is Feed, else response is success or error
     */
    
    func composerPhoto(imageFiles: [UIImage], imageDatas: [[String: String]], privacy: Int, feedText: String?, completion: @escaping (Bool,Any?) -> ()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        var image_files: [Data] = []
        for i in 0..<imageFiles.count {
            if let imageData = imageFiles[i].jpegData(compressionQuality: 0.8) {
                image_files.append(imageData)
            }
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)",
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"
        ]
        
        let urlString = "\(host)/api/v1/composer/photo/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for i in 0..<imageFiles.count {
                let fileName = imageDatas[i]["id"]!
                multipartFormData.append(image_files[i], withName: "image_file", fileName: fileName, mimeType: "image/png")
            }
            
            multipartFormData.append("\(privacy)".data(using: String.Encoding.utf8)!, withName: "privacy")
            if let ft = feedText, !ft.isEmpty {
                multipartFormData.append(ft.data(using: String.Encoding.utf8)!, withName: "feed.text")
            }
        }, to: url, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress.debugDescription)
                })
                
                upload.responseJSON { response in
                    //print response.result
                    print(response.result.debugDescription)
                    completion(true, response.result.value)
                }
                
            case .failure(let encodingError):
                //print encodingError.description
                print(encodingError.localizedDescription)
                completion(false, nil)
            }
        }
        
    }
    
    /*
     POST /composer/video/
     
     Type: MultiPart FormData
     Request data:
     
     file: <Video File>: Object uploaded video.
     title - No required
     description - No required
     thumbnail - No required
     privacy: 0, 1 or 2 - View Privacy API Documentation - required
     feed.text: 'Example Text' - No required
     */
    func composerVideo(videoFile: Data, title: String?, description: String?, thumbnail: UIImage?, privacy: Int, feedText: String?, completion: @escaping (Bool,Any?) -> ()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)",
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"
        ]
        
        let urlString = "\(host)/api/v1/composer/video/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        let fileName = Date().dateTimeString().appending(".mp4")
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(videoFile, withName: "file", fileName: fileName, mimeType: "video/mp4")
            
            if let thumb = thumbnail, let thumbnailData = thumb.jpegData(compressionQuality: 1) {
                let thumbName = Date().dateTimeString().appending(".png")
                multipartFormData.append(thumbnailData, withName: "thumbnail", fileName: thumbName, mimeType: "image/png")
            }
            
            multipartFormData.append("\(privacy)".data(using: String.Encoding.utf8)!, withName: "privacy")
            if let ft = feedText, !ft.isEmpty {
                multipartFormData.append(ft.data(using: String.Encoding.utf8)!, withName: "feed.text")
            }
            
            if let t = title {
                multipartFormData.append(t.data(using: String.Encoding.utf8)!, withName: "title")
            }
            
            if let d = description {
                multipartFormData.append(d.data(using: String.Encoding.utf8)!, withName: "description")
            }
        }, to: url, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress.debugDescription)
                })
                
                upload.responseJSON { response in
                    //print response.result
                    print(response.result.debugDescription)
                    completion(true, response.result.value)
                }
                
            case .failure(let encodingError):
                //print encodingError.description
                print(encodingError.localizedDescription)
                completion(false, nil)
            }
        }
        
    }
    
    func getNotification(completion: @escaping (Bool, FTNotificationResponse?) -> ()) {
        // https://api.feedtrue.com/api/v1/notification/
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/notification/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTNotificationResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func getMoreNotification(nextString: String, completion: @escaping (Bool, FTNotificationResponse?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        guard let url = URL(string: nextString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTNotificationResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                if value.notifications?.count > 0 {
                    completion(true, value)
                    return
                }
                
                completion(false, value)
        }
    }
    
    func getContact(completion: @escaping (Bool, FTContactResponse?) -> ()) {
        // https://api.feedtrue.com/api/v1/chat/contact/
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/chat/contact/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTContactResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func getMoreContact(nextString: String, completion: @escaping (Bool, FTContactResponse?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        guard let url = URL(string: nextString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTContactResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                if value.contacts?.count > 0 {
                    completion(true, value)
                    return
                }
                
                completion(false, value)
        }
    }
    
    
    func getMessage(roomID id: Int, completion: @escaping (Bool, FTMessageResponse?) -> ()) {
        // https://api.feedtrue.com/api/v1/chat/contact/
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/chat/\(String(id))/messages/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTMessageResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func getMoreMessage(nextString: String, completion: @escaping (Bool, FTMessageResponse?)->()) {
        
        guard let token = getToken() else {
            completion(false, nil)
            showLogin()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        guard let url = URL(string: nextString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTMessageResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                if value.messages?.count > 0 {
                    completion(true, value)
                    return
                }
                
                completion(false, value)
        }
    }
    
    /*
     POST https://chapi.feedtrue.com/message/new/
     Request: { text: , room_id: <ROOM_ID> }
     */
    
    func sendMessage(text: String, roomID id: Int, completion: @escaping (Bool, FTMessage?) -> ()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "https://chapi.feedtrue.com/message/new/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        let params:[String: Any] = [
            "text": text,
            "room_id" : id
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTMessage>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }


                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }

                completion(true, value)
        }
    }
    
    func getArticleWithUID(uid: String, completion: @escaping (Bool, FTArticleContent?) -> ()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/blog/\(uid)/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTArticleContent>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    
    func getActivities(completion: @escaping (Bool, FTActivitiesResponse?) -> ()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/activities/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTActivitiesResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    // https://api.feedtrue.com/api/v1/location/?q=<Search_Term>
    func searchLocation(searchTerm: String, completion: @escaping (Bool, FTLocationResponse?) -> ()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/location/?q=\(searchTerm)/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTLocationResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    func getNextLocation(next: String, completion: @escaping (Bool, FTLocationResponse?) -> ()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = next
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTLocationResponse>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
    
    //GET /api/v1/comments/ with Params { "limit": "10", "offset": "10", "content_type": 23, "object_id": 174 }
    
    func getMoreComments(limit: Int, offset: Int, contentType: Int, objectID: Int, completion: @escaping (Bool, Any?) -> ()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let params: [String: Any] = [
            "limit": limit,
            "offset": offset,
            "content_type": contentType,
            "object_id": objectID
        ]
        
        let urlString = "\(host)/api/v1/comments/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
            .response { (response) in
                print(response.response.debugDescription)
        }
    }
    
    func getMoreCommentsByNextURL(next: String, completion: @escaping (Bool, FTComment?) -> ()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = next
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTComment>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
        
    }
    
    func getFeedDetail(uid: String, completion: @escaping (Bool, FTFeedInfo?) -> ()) {
        var headers: HTTPHeaders?
        if let token = getToken() {
            headers = [
                "Authorization": "JWT \(token)"
            ]
        }
        
        let urlString = "\(host)/api/v1/feed/\(uid)/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<FTFeedInfo>) in
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                
                
                guard let value = response.result.value else {
                    completion(false, nil)
                    return
                }
                
                completion(true, value)
        }
    }
}
