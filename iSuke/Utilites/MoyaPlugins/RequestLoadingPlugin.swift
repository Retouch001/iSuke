//
//  RequestLoadingPlugin.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/25.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import Moya
import Result


class RequestLoadingPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        let type = target as! MyService
        switch type {
        case .login:
            MBProgressHUD.showLoding(message: "正在登录...")
        case .changeAvatar:
            MBProgressHUD.showLoding(message: "正在长传...")
        case .msgDetial, .modifySwitch, .setShareUserAlias, .delShareDevice, .operateTimeTask:
            MBProgressHUD.showLoding(message: nil)
        default:
            break
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        MBProgressHUD.dissmiss()
    }
}
