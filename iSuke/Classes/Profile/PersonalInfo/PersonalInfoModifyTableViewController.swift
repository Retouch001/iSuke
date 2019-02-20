//
//  PersonalInfoModifyTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/5.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class PersonalInfoModifyTableViewController: UITableViewController {
    
    @IBOutlet weak var saveBarBtn: UIBarButtonItem!
    @IBOutlet weak var nickNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameTF.addTarget(self, action: #selector(self.textFieldDidChanged(_ :)), for: .editingChanged)
        nickNameTF.text = UserManager.share.loginUser?.loginName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveNickName(_ sender: UIBarButtonItem) {
        var loginUser = UserManager.share.loginUser
        loginUser?.loginName = nickNameTF.text
        
        Network().request(target: MyService.modifyUserInfo(loginUser: loginUser!), success: { [weak self] (dic) in
            UserManager.share.loginUser?.loginName = self?.nickNameTF.text
            UserManager.saveLoginUser(loginUser: UserManager.share.loginUser!)
            self?.nickNameTF.text = UserManager.share.loginUser?.loginName
            self?.navigationController?.popViewController(animated: true)
        })
    }
}

//MARK: TextFieldDelegate---
extension PersonalInfoModifyTableViewController {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if textField.text == UserManager.share.loginUser?.loginName || textField.text?.count == 0 {
            saveBarBtn.isEnabled = false
        }else {
            saveBarBtn.isEnabled = true
        }
    }
}
