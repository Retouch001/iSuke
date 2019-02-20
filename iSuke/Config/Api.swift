//
//  Api.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/23.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON


let LIANG_URL = "http://192.168.8.214:8282"
let DEV_URL   = "http://117.78.48.143"
let DIS_URL   = "http://117.78.48.140"


enum MyService {
    case login(phone: String, val: String, type: Int)
    case verifyCode(phone: String, countryCode: String)
    case checkVerifyCode(phone: String, verifyCode: String)
    case register(phone: String, countryCode: String, token: String, password: String, timeZone: String)
    case resetPsd(phone: String, token: String, password: String)
    case changeAvatar(image: Data)
    case modifyUserInfo(loginUser: LoginUser)
    case msgList(pageNum: Int)
    case msgDetial(id: Int)
    case getDeviceList
    case deviceSwitch(deviceNo: String)
    case modifySwitch(deviceNo: String, no: Int, type: Int, alias: String?, on: Bool?)
    case modifyDevice(deviceNo: String, alias: String)
    case sharedUser(deviceNo: String)
    case delShareDevice(deviceNo: String, phone: String)
    case setShareUserAlias(phone: String, alias: String)
    case searchUser(phone: String)
    case shareDevice(deviceNo: String, phone: String)
    case currentPower(deviceNo: String)
    case historyPower(deviceNo: String, date: String)
    case searchTimeTask
    case operateTimeTask(timerId: Int, type: Int)
    case editTimeTask(timeTask: TimeTask)
    case delDevice(deviceNo: String)
    case setShareDeviceAlias(deviceNo: String, alias: String)
    
    case getScenes
    case getSceneSelection(language: String)
}


extension MyService: TargetType {
    var baseURL: URL { return URL(string: DEV_URL)! }
    
    var path: String {
        switch self {
        case .login:
            return "/iSukeServer/user/login"
        case .verifyCode:
            return "/iSukeServer/user/getVerifyCode"
        case .checkVerifyCode:
            return "/iSukeServer/user/checkVerifyCode"
        case .register:
            return "/iSukeServer/user/register"
        case .resetPsd:
            return "/iSukeServer/user/resetPassword"
        case .changeAvatar:
            return "/iSukeServer/user/changeAvatar"
        case .modifyUserInfo:
            return "/iSukeServer/user/modifyUserInfo"
        case .msgList:
            return "/iSukeServer/msg/list"
        case .msgDetial:
            return "/iSukeServer/msg/detail"
        case .getDeviceList:
            return "/iSukeServer/device/getDeviceList"
        case .deviceSwitch:
            return "/iSukeServer/device/deviceSwitch"
        case .modifySwitch:
            return "/iSukeServer/device/switch"
        case .modifyDevice:
            return "/iSukeServer/device/setDeviceAlias"
        case .sharedUser:
            return "/iSukeServer/device/sharedUser"
        case .delShareDevice:
            return "/iSukeServer/device/delShareDevice"
        case .setShareUserAlias:
            return "/iSukeServer/device/setShareUserAlias"
        case .searchUser:
            return "/iSukeServer/user/queryUserByPhone"
        case .shareDevice:
            return "/iSukeServer/device/shareDevice"
        case .currentPower:
            return "/iSukeServer/device/consumeDetail"
        case .historyPower:
            return "/iSukeServer/device/consumeHistory"
        case .searchTimeTask:
            return "/iSukeServer/timerTask/list"
        case .operateTimeTask:
            return "/iSukeServer/timerTask/operate"
        case .editTimeTask:
            return "/iSukeServer/timerTask/edit"
        case .delDevice:
            return "/iSukeServer/device/delDevice"
        case .setShareDeviceAlias:
            return "/iSukeServer/device/setDeviceAliasShareToMe"
        case .getScenes:
            return "/iSukeServer/smartScene/list"
        case .getSceneSelection:
            return "/iSukeServer/smartScene/getSceneSelection"
        }
        
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case let .login(phone, val, type):
            return .requestParameters(parameters: ["phone": phone, "val": val, "type": type], encoding: URLEncoding.default)
        case let .verifyCode(phone, countryCode):
            return .requestParameters(parameters: ["phone": phone, "countryCode": countryCode], encoding: URLEncoding.default)
        case let .checkVerifyCode(phone, verifyCode):
            return .requestParameters(parameters: ["phone": phone, "verifyCode": verifyCode], encoding: URLEncoding.default)
        case let .register(phone, countryCode, token, password, timeZone):
            return .requestParameters(parameters:["phone": phone, "countryCode": countryCode, "token":token, "password":password, "timeZone":timeZone], encoding: URLEncoding.default)
        case let .resetPsd(phone, token, password):
            return .requestParameters(parameters: ["phone": phone, "token": token, "password": password], encoding: URLEncoding.default)
        case let .changeAvatar(data):
            let multipartFormData = [MultipartFormData(provider: .data(data), name: "avatar", fileName: "avatar", mimeType: "image/jpeg")]
            return .uploadMultipart(multipartFormData)
        case let .modifyUserInfo(loginUser):
            let param: [String: Any] = ["appUserId": loginUser.appUserId!, "loginName": loginUser.loginName!, "phone": loginUser.phone!, "countryCode": loginUser.countryCode!, "avatar": loginUser.avatar!, "timeZone": loginUser.timeZone!, "language": loginUser.language!]
            return .requestJSONEncodable(JSON(param))
        case let .msgList(pageNum):
            return .requestParameters(parameters: ["pageNum": pageNum], encoding: URLEncoding.default)
        case let .msgDetial(id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.default)
        case .getDeviceList, .getScenes:
            return .requestPlain
        case let .deviceSwitch(deviceNo):
            return .requestParameters(parameters: ["deviceNo": deviceNo], encoding: URLEncoding.default)
        case let .modifySwitch(deviceNo, no, type, alias, on):
            var dic: [String: Any] = ["deviceNo": deviceNo, "no": no, "type": type]
            if let tempAlias = alias {
                dic["alias"] = tempAlias
            }
            if let tempOn = on {
                dic["on"] = tempOn
            }
            return .requestParameters(parameters: dic, encoding: URLEncoding.default)
            
        case let .modifyDevice(deviceNo, alias), let .setShareDeviceAlias(deviceNo, alias):
            return .requestParameters(parameters: ["deviceNo": deviceNo, "alias": alias], encoding: URLEncoding.default)
        case let .sharedUser(deviceNo):
            return .requestParameters(parameters: ["deviceNo": deviceNo], encoding: URLEncoding.default)
        case let .delShareDevice(deviceNo, phone):
            return .requestParameters(parameters: ["deviceNo": deviceNo, "phone": phone], encoding: URLEncoding.default)
        case let .setShareUserAlias(phone, alias):
            return .requestParameters(parameters: ["phone": phone, "alias": alias], encoding: URLEncoding.default)
        case let .searchUser(phone):
            return .requestParameters(parameters: ["phone": phone], encoding: URLEncoding.default)
        case let .shareDevice(deviceNo, phone):
            return .requestParameters(parameters: ["phone": phone, "deviceNo": deviceNo], encoding: URLEncoding.default)
        case let .currentPower(deviceNo):
            return .requestParameters(parameters: ["deviceNo": deviceNo], encoding: URLEncoding.default)
        case let .historyPower(deviceNo, date):
            return .requestParameters(parameters: ["deviceNo": deviceNo, "date": date], encoding: URLEncoding.default)
        case .searchTimeTask:
            return .requestPlain
        case let .operateTimeTask(timerId, type):
            return .requestParameters(parameters: ["timerId": timerId, "type": type], encoding: URLEncoding.default)
        case let .editTimeTask(timeTask):
            return .requestJSONEncodable(JSON(timeTask.toJSON()!))
        case let .delDevice(deviceNo):
            return .requestParameters(parameters: ["deviceNo": deviceNo], encoding: URLEncoding.default)
        case let .getSceneSelection(language):
            return .requestParameters(parameters: ["language": language], encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        var params = [String: String]()
        switch self {
        case .modifyUserInfo, .editTimeTask:
            params["Content-Type"] = "application/json"
        default:break
        }
        if let token = UserManager.share.loginUser?.token {
            params["token"] = token
        }
        return params
    }
}
