//
//  Switch.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/18.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import HandyJSON


struct Switch: HandyJSON {
    var no: Int = 0
    var status: Bool = false
    var createTime: String?
    var updateTime: String?
    var deviceNo: String?
    var deviceSwitchId: Int = 0
    var lastStatus: Int = 0
    var alias: String?
}
