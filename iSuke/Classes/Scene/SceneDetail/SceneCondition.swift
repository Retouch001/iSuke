//
//  SceneCondition.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/25.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import HandyJSON

struct SceneCondition: HandyJSON {
    var avatar: String?
    var option: [String]?
    var name: String?
    var hightlightAvatar: String?
    var type: Int?
    var subOption: [String]?
}
