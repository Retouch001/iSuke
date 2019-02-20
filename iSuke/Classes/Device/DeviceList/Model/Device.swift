
//
//  Device.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/13.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import HandyJSON

struct Device: HandyJSON {
    var sharedDevices = [MyDevice]()
    var myDevices = [MyDevice]()
}


struct MyDevice: HandyJSON {
    var deviceId: Int = 0
    var deviceNo: String?
    var deviceName: String?
    var alias: String?
    
    var typeName: String?
    var phone: String?
}

struct SharedDevice: HandyJSON {
    var deviceId: String?
    var deviceNo: String?
    var deviceName: String?
    var alias: String?
    
    var phone: String?
}
