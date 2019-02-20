//
//  LoginUser.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/6.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

struct LoginUser: Codable,HandyJSON{
    var appUserId: Int?
    var phone: String?
    var avatar: String?
    var loginName: String?
    var timeZone: String?
    var countryCode: String?
    var language: String?
    var token: String?
}

