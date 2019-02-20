//
//  AppDelegate.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/18.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configNavigationBar()
        let loginUser = UserManager.getLoginUser()
        if loginUser == nil {
            window?.rootViewController = UIStoryboard(storyboard: .login).instantiateInitialViewController()
        }else {
            UserManager.share.loginUser = loginUser
            window?.rootViewController = UIStoryboard(storyboard: .main).instantiateInitialViewController()
        }
        RTFPSStatusView.shared.open(in: nil)
        IQKeyboardManager.shared.enable = true

        return true
    }
}

//MARK: 统一配置导航栏和tabbar外观
extension AppDelegate {
    func configNavigationBar() {
        UINavigationBar.appearance().shadowImage =  UIImage()
        UINavigationBar.appearance().setBackgroundImage(R.image.topbg(), for:UIBarMetrics.default)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
    }
}



