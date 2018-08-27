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

class WebService: NSObject {
    
    static let `default`: WebService = WebService()
    let host = "https://api.feedtrue.com"
    
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
            .validate()
            .responseObject { (response: DataResponse<SignInResponse>) in
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
            .validate()
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
}
