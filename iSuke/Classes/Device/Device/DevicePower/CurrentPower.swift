//
//  CurrentPower.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/20.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import HandyJSON

struct CurrentPower: HandyJSON {
    var voltage: Int = 0
    var current: Int = 0
    var electricity: Int = 0
    var consume: Int = 0
}

struct HistoryPower: HandyJSON {
    var date: String?
    var total: Int = 0
}
