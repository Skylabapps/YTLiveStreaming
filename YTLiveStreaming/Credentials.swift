//
//  Credentials.swift
//  YTLiveStreaming
//
//  Created by Sergey Krotkih on 11/12/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import UIKit

public class Credentials: NSObject {
    private static var _settingDictionary: NSDictionary?
    
    class var settingDictionary: NSDictionary? {
        if Credentials._settingDictionary == nil {
            //let bundle = Bundle(for: self.classForCoder())
            let bundle = Bundle(identifier: "org.cocoapods.SkylabCore")!
            if let path = bundle.path(forResource: "LiveStreamInfo", ofType: "plist") {
                Credentials._settingDictionary = NSMutableDictionary(contentsOfFile: path)
            }
            let mainBundle = Bundle.main
            if let path = mainBundle.path(forResource: "GoogleService-Info", ofType: "plist") {
                let glData = NSDictionary(contentsOfFile: path)!
                Credentials.authDictionary?.setValue(glData["API_KEY"], forKey: "APIKEY")
            }
        }
        return Credentials._settingDictionary
    }
    
    class var authDictionary: NSDictionary? {
        if let plist = Credentials.settingDictionary {
            if let authDic = plist["Auth"] as? NSDictionary? {
                return authDic
            }
        }
        return nil
    }
    
    class var liveAPIDictionary: NSDictionary? {
        if let plist = Credentials.settingDictionary {
            if let authDic = plist["LiveAPI"] as? NSDictionary? {
                return authDic
            }
        }
        return nil
    }
    
    class var liveRequestDictionary: NSDictionary? {
        if let plist = Credentials.settingDictionary {
            if let authDic = plist["LiveRequest"] as? NSDictionary? {
                return authDic
            }
        }
        return nil
    }
    
    class var privacyStatusDictionary: NSDictionary? {
        if let plist = Credentials.settingDictionary {
            if let authDic = plist["PrivacyStatus"] as? NSDictionary? {
                return authDic
            }
        }
        return nil
    }
}
