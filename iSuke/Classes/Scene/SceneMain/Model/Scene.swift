//
//  Scene.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/23.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import HandyJSON

struct Scene: HandyJSON {
    var id: Int = 0

    var name: String?
    var compare: Int = 0
    var openStatus: Int = 0
    var type: Int?
    
    var conditionVal: String?
    var zone: String?
    var cityCode: String?
    var deviceList: String?
    var city: String?
    var la_lo: String?
    var executeStatus: Int?
}
