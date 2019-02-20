//
//  SettingTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/5.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension SettingTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            let alertVC = UIAlertController(title: "退出登录？", message: nil, preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "确定", style: .default) { (UIAlertAciton) in
                UserManager.clearLoginUserInfo()
                kRootVC = UIStoryboard(storyboard: .login).instantiateInitialViewController()
            }
            actionOK.setValue(UIColor.theme, forKey: "titleTextColor")
            let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            actionCancel.setValue(UIColor.theme, forKey: "titleTextColor")
            alertVC.addAction(actionCancel)
            alertVC.addAction(actionOK)
            present(alertVC, animated: true, completion: nil)
        default:
            break
        }
    }
}
