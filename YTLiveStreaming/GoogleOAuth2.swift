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

public class GoogleOAuth2: NSObject {
    
    //let Keychain:  KeychainPasswordItem
    let kOAuth2AccessTokenService: String = "OAuth2AccessToken"
    
    public class var sharedInstance: GoogleOAuth2 {
        struct Singleton {
            static let instance = GoogleOAuth2()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        do  {
            self.accessToken = try KeychainPasswordItem(service: LiveAPI.BaseURL, account: kOAuth2AccessTokenService).readPassword();
        }
        catch {
            NSLog("YT: Error fetching password items -)")
        }
    }
    
    var isAccessTokenPresented: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        didSet {
            do  {
                try KeychainPasswordItem(service: LiveAPI.BaseURL, account: kOAuth2AccessTokenService).savePassword(accessToken ?? " ")
            }
            catch {
                NSLog("YT: Error fetching password items )")
            }
        }
    }
    private var _refreshToken: String!
    public var refreshToken: String! {
        get {
            return _refreshToken
        }
        set {
            _refreshToken = String(data: Data(base64Encoded: newValue) ?? Data(), encoding: .utf8)
        }
    }
    public var expirationDate: Date!
    public var clientId: String!
    public var clientSecret: String!
    
    public func clearToken() {
        do{
            try KeychainPasswordItem(service: LiveAPI.BaseURL, account: kOAuth2AccessTokenService).deleteItem()
            _refreshToken = nil
            expirationDate = nil
            clientId = nil
            clientSecret = nil
        } catch {
            NSLog("YT: Error fetching password items)")
        }
    }
    
    public func requestToken(_ completion: @escaping (String?) -> Void) {
        
        if let token = accessToken, expirationDate != nil, expirationDate > Date() {
            completion(token)
            return
        }
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let url = Auth.TokenURL
        Alamofire.request(url,
                          method: .post,
                          parameters: ["client_id": GoogleOAuth2.sharedInstance.clientId!,
                                       "client_secret": GoogleOAuth2.sharedInstance.clientSecret!,
                                       "refresh_token": GoogleOAuth2.sharedInstance.refreshToken!,
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
