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

                completion(true, value)
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
                
                completion(true, value)
        }
    }
    
    // Login
    
    func login(username: String, password: String, completion: @escaping (HTTPURLResponse?) -> ()) {
        let headers = [
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            "Cache-Control": "no-cache",
            "Postman-Token": "b25464fa-169e-4533-8010-5f3e35bde30e"
        ]
        let parameters = [
            [
                "name": "username",
                "value": username
            ],
            [
                "name": "password",
                "value": password
            ]
        ]
        
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        
        var body = ""
        var error: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                let fileContent = try? String(contentsOfFile: filename, encoding: .utf8)
                if (error != nil) {
                    print(error ?? "")
                }
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent ?? ""
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(host)/api/v1/auth/login/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        body.appendingFormat("\r\n==\(boundary)--\r\n")
        let postData = body.data(using: .utf8)//[body dataUsingEncoding:NSUTF8StringEncoding];
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })
        
        dataTask.resume()
    }
}
