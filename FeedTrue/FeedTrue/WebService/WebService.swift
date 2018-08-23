//
//  WebService.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/23/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import Alamofire

class WebService: NSObject {

    static let `default`: WebService = WebService()
    let host = "https://api.feedtrue.com"
    
    func signIn(username: String, password: String, completion: @escaping (Bool, String?)->()) {
        let params:[String: Any] = [
            "username": username,
            "password": password
        ]
        let urlString = "\(host)/api/v1/api-token-auth/"
        
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
        .validate()
            .responseJSON { (response) in
                NSLog(response.debugDescription)
                guard response.result.isSuccess else {
                    completion(false, nil)
                    return
                }
                guard let value = response.result.value as? [String: Any],
                    let token = value["token"] as? String else {
                        completion(false, nil)
                        return
                }
                
                // parse data
                completion(true, token)
        }
    }
}
