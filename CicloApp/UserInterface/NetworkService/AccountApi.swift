//
//  AccountApi.swift
//  CicloApp
//
//  Created by Владимир Моисеев on 12.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//


import Foundation
import Alamofire

class AccountApi {
    
    private init() {}
    static let shared = AccountApi()
    
    private let cicloApiUrl = "http://ciclo-app-development.cloudapps.devinstance.de"
    private let authorization = "Basic Y2ljbG8tYXBwOmZqaGR2a2d1ZGlybGxnZm0ueGZjZ2po"
    
    // if user need to SignOut this values sets to nil
    var accessToken: String?
    var refreshToken: String?
    var userId: String?
    
    
     func isConnectedToInternet() -> Bool {
        let connection = NetworkReachabilityManager()!.isReachable
        return connection
    }
    
    
    func register(user: CAUser, view: UIView, completion: @escaping (Bool) -> Void) {
        
        ViewControllerUtils().showActivityIndicator(uiView: view)
        
        let params: [String: Any] = [
            "email": user.email,
            "repeatPassword": user.repeatPassword,
            "password": user.password
        ]
        
        request(cicloApiUrl + "/api/accounts", method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { responseJSON in
            
            ViewControllerUtils().hideActivityIndicator(uiView: view)
            
            guard let statusCode = responseJSON.response?.statusCode else {
                completion(false)
                return
            }
            
            completion((200..<300).contains(statusCode) ? true : false)
        }
    }
    

    

    func getToken(user: CAUser, view: UIView, completion: @escaping (Bool) -> Void) {

        guard let url = URL(string: cicloApiUrl + "/api/oauth/token?username=\(user.email)&password=\(user.password)&grant_type=password") else {
            completion(false)
            return
        }
        
        ViewControllerUtils().showActivityIndicator(uiView: view)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")

        Alamofire.request(request).responseJSON { response in
            
            ViewControllerUtils().hideActivityIndicator(uiView: view)
            
            switch response.result {
            case .success(let value):
                guard let jsonObject = value as? [String: Any] else { return }

                self.accessToken = jsonObject["access_token"] as? String
                self.refreshToken = jsonObject["refresh_token"] as? String
                self.userId = jsonObject["userId"] as? String

                guard self.accessToken != nil, self.refreshToken != nil, self.userId != nil else {
                    completion(false)
                    return
                }
                completion(true)
                return

            case .failure(let error):
                print("error", error)
                completion(false)
                return
            }
        }
    }

    
    
    
    
    func resetPassword(for email: String, view: UIView, completion: @escaping (Bool) -> Void) {
        
        ViewControllerUtils().showActivityIndicator(uiView: view)
        
        let params: [String: Any] = [
            "email": email
        ]
        
        request(cicloApiUrl + "/api/accounts/reset-password", method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { responseJSON in
            
            ViewControllerUtils().hideActivityIndicator(uiView: view)
            
            guard let statusCode = responseJSON.response?.statusCode else {
                completion(false)
                return
            }
            
            completion((200..<205).contains(statusCode) ? true : false)
        }
    }
    
    
}
