//
//  Constants.swift
//  YouTubeLiveVideo
//
//  Created by Sergey Krotkih on 10/28/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

import UIKit

public struct Auth {
    static let ClientSecret: String = Credentials.authDictionary != nil ? Credentials.authDictionary!["ClientSecret"] as! String : ""
    static let AuthorizeURL: String = Credentials.authDictionary != nil ? Credentials.authDictionary!["AuthorizeURL"] as! String : "https://accounts.google.com/o/oauth2/auth"
    static let TokenURL: String     = Credentials.authDictionary != nil ? Credentials.authDictionary!["TokenURL"] as! String : "https://www.googleapis.com/oauth2/v3/token"
    static let RedirectURL: String   = Credentials.authDictionary != nil ? Credentials.authDictionary!["RedirectURL"] as! String : "http://localhost"
}

public struct LiveAPI {
    static let BaseURL: String        = Credentials.liveAPIDictionary != nil ? Credentials.liveAPIDictionary!["BaseURL"] as! String : "https://www.googleapis.com/youtube/v3"
    static let Resolution: String     = Credentials.liveAPIDictionary != nil ? Credentials.liveAPIDictionary!["Resolution"] as! String : "720p"
    static let FrameRate: String      = Credentials.liveAPIDictionary != nil ? Credentials.liveAPIDictionary!["FrameRate"] as! String : "60fps"
    static let IngestionType: String  = Credentials.liveAPIDictionary != nil ? Credentials.liveAPIDictionary!["IngestionType"] as! String : "rtmp" 
}

public struct LiveRequest {
    static let MaxResultObjects:Int = Credentials.liveRequestDictionary != nil ? Int(Credentials.liveRequestDictionary!["MaxResultObjects"] as! String)! : 50
}


public struct privacyStatus {
    static let PrivacyStatusPublic: String    = Credentials.privacyStatusDictionary != nil ? Credentials.privacyStatusDictionary!["PrivacyStatusPublic"] as! String : "public"
    static let PrivacyStatusUnlisted: String  = Credentials.privacyStatusDictionary != nil ? Credentials.privacyStatusDictionary!["PrivacyStatusUnlisted"] as! String : "unlisted"
}


