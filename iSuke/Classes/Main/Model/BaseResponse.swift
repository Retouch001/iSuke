//
//  Response.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/25.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import HandyJSON

let SUCCESS = "000"

struct BaseResponse: HandyJSON {
    var code: String?
    var msg: String?
    var data: Any?
}
