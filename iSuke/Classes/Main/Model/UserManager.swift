//
//  User.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/26.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation

let kCache_Key = "kCache_Key"


class UserManager {
    
    var loginUser: LoginUser?
    
    static let share = UserManager()
        
    public class func saveLoginUser(loginUser: LoginUser) {
        let loginUserData = try? JSONEncoder().encode(loginUser)
        UserDefaults.standard.set(loginUserData, forKey: kCache_Key)
        UserDefaults.standard.synchronize()
    }
    
    public class func getLoginUser() -> LoginUser? {
        let loginUserData = UserDefaults.standard.object(forKey: kCache_Key)
        guard loginUserData != nil else {
            return nil
        }
        let loginUser = try? JSONDecoder().decode(LoginUser.self, from: loginUserData as! Data)
        return loginUser
    }
    
    public class func clearLoginUserInfo() {
        UserDefaults.standard.removeObject(forKey: kCache_Key)
    }
}
