//
//  Credentials.swift
//  YTLiveStreaming
//
//  Created by Sergey Krotkih on 11/12/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import UIKit

public class Credentials: NSObject {
    private static var _APIkey: String?
    class var APIkey: String {
        Credentials._APIkey = "AIzaSyCihFS-4d4fP9pKQG3sP1-BUHblLN07chE"
        return Credentials._APIkey!
    }
}
