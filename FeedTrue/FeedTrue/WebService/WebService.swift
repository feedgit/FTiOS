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

class WebService: NSObject, FTCoreServiceComponent {
    
    static let `default`: WebService = WebService()
    let host = "https://api.feedtrue.com"
    
    func setup() {
        
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
    
    func getUserInfo(token: String, username: String, completion: @escaping (Bool, FTUserProfileResponse?)->()) {
        let params:[String: Any] = [
            "access_token": "\(token)"
        ]
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/users/\(username)/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
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
    
    func getUserAbout(token: String, username: String, completion: @escaping (Bool, FTAboutReponse?)->()) {
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
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
    
    func getFeed(page: Int?, per_page: Int?, username: String?, token: String, completion: @escaping (Bool, FTFeedResponse?) -> ()) {
        // https://api.feedtrue.com/api/v1/f/?page=1&per_page=1
        let params:[String: Any] = [
            "page": page ?? 1,
            "per_page" : per_page ?? 5
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let urlString = "\(host)/api/v1/f/"
        
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
    
    func deleteFeed(feedID: String, token: String, completion: @escaping (Bool, Any?) -> ()) {
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
    
    func follow(token: String, username: String, completion: @escaping (Bool, String?)->()) {
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
    
    func secretFollow(token: String, username: String, completion: @escaping (Bool, String?)->()) {
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
    
    func unfollow(token: String, username: String, completion: @escaping (Bool, String?)->()) {
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
    func react(token: String, ct_name: String, ct_id: Int, react_type: String, completion: @escaping (Bool, String?)->()) {
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
    func removeReact(token: String, ct_name: String, ct_id: Int, completion: @escaping (Bool, String?)->()) {
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
    func saveFeed(token: String, ct_name: String, ct_id: Int, completion: @escaping (Bool, String?)->()) {
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
    
    func removeSaveFeed(token: String, ct_name: String, ct_id: Int, completion: @escaping (Bool, String?)->()) {
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
    
    func sendComment(token: String, ct_name: String, ct_id: Int, comment: String, parentID: Int?, completion: @escaping (Bool, FTCommentMappable?)->()) {
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(token)"
        ]
        
        let params:[String: Any] = [
            "content_type": ct_name,
            "object_id" : ct_id,
            "comment": comment
        ]
        
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
}
