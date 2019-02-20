//
//  Message.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/7.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import HandyJSON

struct Message: HandyJSON {
    var list = [List]()
    var pageSize: Int = 0
    var navigatepageNums = [Int]()
    var pageNum: Int = 0
}

struct List: HandyJSON {
    var id: Int = 0
    var notifyTitle: String?
    var msgTitle: String?
    var sender: Int = 0
    var type: Int = 0
    var createTime: String?
}
