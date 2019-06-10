//
//  GoogleOAuth2.swift
//  YTLiveStreaming
//
//  Created by Sergey Krotkih on 10/28/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation
import UIKit

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
    
    public var accessToken: String? {
        didSet {
            do  {
                try KeychainPasswordItem(service: LiveAPI.BaseURL, account: kOAuth2AccessTokenService).savePassword(accessToken ?? " ")
            }
            catch {
                NSLog("YT: Error fetching password items )")
            }
        }
    }
    
    public func clearToken() {
        do{
            try KeychainPasswordItem(service: LiveAPI.BaseURL, account: kOAuth2AccessTokenService).deleteItem()
        }
        catch {
            NSLog("YT: Error fetching password items)")
        }
    }
    
    func requestToken(_ completion: @escaping (String?) -> Void) {
        completion(accessToken)
    }
}
