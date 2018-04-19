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
    //temp >>>>>>>
    var version: Double = 1.0
    //<<<<<<<<
    
    private init() {}
    static let shared = AccountApi()
    
    private let cicloApiUrl = "http://ciclo-app-development.cloudapps.devinstance.de"
    private let authorization = "Basic Y2ljbG8tYXBwOmZqaGR2a2d1ZGlybGxnZm0ueGZjZ2po"
    
    // if user need to SignOut this values sets to nil
    var accessToken: String?
    var refreshToken: String?
    var userId: String?
    var userEmail: String?
    var mainJson: [String : Any]?
    
    
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

                self.mainJson = jsonObject
                self.accessToken = jsonObject["access_token"] as? String
                self.refreshToken = jsonObject["refresh_token"] as? String
                self.userId = jsonObject["userId"] as? String

                guard self.accessToken != nil, self.refreshToken != nil, self.userId != nil else {
                    completion(false)
                    return
                }
                self.userEmail = user.email
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
    
    
    
    
    
    
    //_______________________UPLOAD
    
    func upload(_ data: Data, filename: String, view:UIView, completion: @escaping (Bool) -> Void) {
        
        ///start animation
        
        let headers = ["Content-Type":"multipart/form-data", "Accept":"application/json", "Authorization" : "Bearer " + (accessToken ?? "")]
        let url = try! URLRequest(url: URL(string: cicloApiUrl + "/api/tracks/upload")!, method: .post, headers: headers)
        
        let params = mainJson ?? [:]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "file", fileName: "\(filename).jpeg", mimeType: "image/jpeg")
            
            multipartFormData.append(jsonData!, withName: "userDetails")
            
        }, with: url) {  result in
            ///end animation
            switch result {
            case .success(let upload, _, _):
            
                upload.responseJSON { response in
                    
                    guard let statusCode = response.response?.statusCode else {
                        completion(false)
                        return
                    }
                    
                    completion((200..<205).contains(statusCode) ? true : false)
                }
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                completion(false)
                return
            }
        }
    }
    


// __________ Firmware
    
 
    
    func findActualVersion(completion: @escaping (Bool, String?) -> Void) {
        
        guard let url = URL(string: cicloApiUrl + "/api/firmwares") else {
            completion(false, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + (accessToken ?? ""), forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                var id: String? = nil

                guard let jsonObject = value as? [String: Any] else { return }
                
                if let content = jsonObject["content"] as? [[String: Any]] {
                    for i in content {
                        if let vers = i["version"] as? String, let tempNumber: Double = Double(vers) {
                            if tempNumber > self.version {
                                id = i["id"] as? String
                                self.version = tempNumber
                            } else {
                                print("установлена последняя прошивка")
                            }
                        }
                    }
                }

                if id != nil {
                    completion(true, id)
                } else {
                   completion(false, nil)
                }
                
            case .failure(let error):
                print("error", error)
                completion(false, nil)
                return
            }
            
        }
    }
    
    
    
    func getFirmware(id: String, view: UIView, completion: @escaping (Bool) -> Void) {

        guard let url = URL(string: cicloApiUrl + "/api/firmwares/share/\(id)") else {
            completion(false)
            return
        }
        ViewControllerUtils().showActivityIndicator(uiView: view)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("text/plain", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + (accessToken ?? ""), forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseString { response in
            
            ViewControllerUtils().hideActivityIndicator(uiView: view)
            switch response.result {
                
            case .success(let value):
                self.downloadFirmware(url: value, completion: { (downloaded) in
                    if downloaded {
                        completion(true)
                    }
                })
                
            case .failure(let error):
                print("error", error)
                completion(false)
                return
            }
        }
    }
    
    
    
    func downloadFirmware(url: String, completion: @escaping (Bool) -> Void){
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = URL(fileURLWithPath: getDirectoryPath())
            documentsURL.appendPathComponent("version")
            return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to: destination).downloadProgress { (progress) in
            let aaa = (String)(progress.fractionCompleted)
            print(aaa)
            }.responseData { response in
            if let destinationUrl = response.destinationURL {
                print("destinationUrl \(destinationUrl.absoluteURL)")
                ///url to data///
                UserDefaults.standard.set(destinationUrl.absoluteURL, forKey: "destinationUrl")
                completion(true)
            }
        }
        
    }
    
}






