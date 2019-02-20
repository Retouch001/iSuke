//
//  MBHUDExtensions.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/11.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation


public extension MBProgressHUD {
    //显示提示文字
    public class func showMessage(message: String) {
        let hud = MBProgressHUD.showAdded(to: ((UIApplication.shared.delegate?.window)!)!, animated: true)
        hud.label.textColor = UIColor.white
        hud.label.font = UIFont.systemFont(ofSize: 15)
        hud.bezelView.color = UIColor.black
        hud.contentColor = UIColor.white
        hud.bezelView.style = .solidColor
        hud.margin = 15
        hud.mode = .text
        hud.label.text = message
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
    //显示转菊花(可能带文字)
    public class func showLoding(message: String?) {
        let hud = MBProgressHUD.showAdded(to: ((UIApplication.shared.delegate?.window)!)!, animated: true)
        hud.label.textColor = UIColor.white
        hud.label.font = UIFont.systemFont(ofSize: 15)
        hud.bezelView.color = UIColor.black
        hud.contentColor = UIColor.white
        hud.bezelView.style = .solidColor
        hud.margin = 15
        hud.label.text = message
    }
    
    public class func dissmiss() {
        hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
    }
    
}
