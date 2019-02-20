//
//  TimeTask.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/20.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import HandyJSON

struct TimeTask: HandyJSON {
    var timerId: Int?
    var appUserId: Int?
    var deviceId: Int?

    var time: String?

    var mon: Int = 0
    var tue: Int = 0
    var wed: Int = 0
    var thur: Int = 0
    var fri: Int = 0
    var sat: Int = 0
    var sun: Int = 0
    
    var status: Int = 0
    var execute: Int = 0
    
    
    func weeksString() ->  String {
        var str = String()
        if mon == 1 { str = str + " 周一" }
        if tue == 1 { str = str + " 周二"}
        if wed == 1 { str = str + " 周三"}
        if thur == 1 { str = str + " 周四" }
        if fri == 1 { str = str + " 周五" }
        if sat == 1 { str = str + " 周六" }
        if sun == 1 { str = str + " 周日" }
        return str
    }
}
