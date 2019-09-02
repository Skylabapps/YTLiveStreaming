//
//  GoogleOAuth2.swift
//  YTLiveStreaming
//
//  Created by Sergey Krotkih on 10/28/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

// Developer console
// https://console.developers.google.com/apis

// Create your own clientID at https://console.developers.google.com/project (secret can be left blank!)
// For more info see https://developers.google.com/identity/protocols/OAuth2WebServer#handlingtheresponse
// And https://developers.google.com/+/web/api/rest/oauth

public class GoogleOAuth2 {
    
    public class var sharedInstance: GoogleOAuth2 {
        struct Singleton {
            static let instance = GoogleOAuth2()
        }
        return Singleton.instance
    }
    
    // ACCESS TOKEN
    private var accessToken: String?
    
    // REFRESH TOKEN
    private var refreshToken: String?
    public func setRefreshToken(_ token: String) {
        if let tokenData = Data(base64Encoded: token) {
            refreshToken = String(data: tokenData, encoding: .utf8)
        }
    }
    // EXPIRATION
    private var expirationDate: Date?
    
    // CLIENT ID
    private var clientId: String?
    
    // CLIENT SECRET
    private var clientSecret: String?
    
    public func refreshConfig(refreshToken: String, clientId: String, clientSecret: String) {
        
        clearTokens()
        
        setRefreshToken(refreshToken)
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    public var debugInfo: [String: String] {
        return ["refreshToken": "\(String(describing: refreshToken))",
            "accessToken": "\(String(describing: accessToken))",
            "expirationDate": "\(String(describing: expirationDate))",
            "clientId": "\(String(describing: clientId))",
            "clientSecret": "\(String(describing: clientSecret))"]
    }
}

extension GoogleOAuth2 {
    
    private func clearTokens() {
        refreshToken = nil
        accessToken = nil
        expirationDate = nil
        clientId = nil
        clientSecret = nil
    }
    
    public func requestToken(_ completion: @escaping (String?) -> Void) {
        
        guard let clientId = clientId, let clientSecret = clientSecret, let refreshToken = refreshToken else {
            completion(nil)
            return
        }
        
        if let token = accessToken, let expDate = expirationDate, expDate > Date() {
            completion(token)
            return
        }
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let url = Auth.TokenURL
        Alamofire.request(url,
                          method: .post,
                          parameters: ["client_id": clientId,
                                       "client_secret": clientSecret,
                                       "refresh_token": refreshToken,
                                       "grant_type": "refresh_token"],
                          headers: headers)
            .validate()
            .responseJSON { [weak self] response in
                
                switch response.result {
                case let .success(data) where data is [String: Any]:
                    
                    let info = data as! [String: Any]
                    self?.accessToken = info["access_token"] as? String
                    self?.expirationDate = Date(timeIntervalSinceNow: info["expires_in"] as? Double ?? 3600.0)
                    
                    completion(self?.accessToken)
                    
                case .failure(let error):
                    NSLog("YT: System Error: " +  error.localizedDescription)
                    completion(nil)
                default:
                    NSLog("YT: System Error")
                    completion(nil)
                }
        }
    }
}
