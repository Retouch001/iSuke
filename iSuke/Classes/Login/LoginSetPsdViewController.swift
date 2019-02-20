//
//  LoginSetPsdViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/27.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class LoginSetPsdViewController: UIViewController {

    var inputPsdType: InputPsdType = .register
    var phone = ""
    var token = ""
    var countryCode = ""
    var timeZone: String {
        var timeZone = NSTimeZone.local.localizedName(for: .standard, locale: nil)
        timeZone?.slice(at: 3)
        return timeZone!
    }
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var passwordAgainTextField: HoshiTextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChanged(_ :)), for: .editingChanged)
        passwordAgainTextField.addTarget(self, action: #selector(self.textFieldDidChanged(_ :)), for: .editingChanged)
        print(inputPsdType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch inputPsdType {
        case .register:
            topTitleLabel.text = "设置密码"
            registerBtn.setTitle("完成注册", for: .normal)
        case .resetPsd:
            topTitleLabel.text = "请重设密码"
            registerBtn.setTitle("重设密码", for: .normal)
        }
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        guard !(passwordTextField.text?.isEmpty)! && !(passwordAgainTextField.text?.isEmpty)! else {
            registerBtn.backgroundColor = UIColor.unableBtn
            registerBtn.isEnabled = false
            return
        }
        registerBtn.backgroundColor = UIColor.theme
        registerBtn.isEnabled = true
    }
    
    @IBAction func register(_ sender: Any) {
        guard passwordTextField.text == passwordAgainTextField.text else {
            let hud = MBProgressHUD.showAdded(to: (kRootVC?.view)!, animated: true)
            hud.label.text = "密码输入不一致"
            hud.mode = .text
            hud.hide(animated: true, afterDelay: 1)
            return
        }
        
        let provider = MoyaProvider<MyService>(plugins: [MyNetworkLoggerPlugin(), RequestLoadingPlugin()])
        
        switch self.inputPsdType{
        case .register:
            provider.request(.register(phone: phone, countryCode:countryCode, token:token, password:passwordTextField.text!.md5, timeZone: timeZone)) { (result) in
                switch result{
                case let .success(moyaResponse):break
//                    let rootModel = RooteModel.init(jsonData: JSON.init(moyaResponse.data))
//                    if rootModel.code == RT_SUCCESS {
//                        provider.request(.login(phone: self.phone, val:self.passwordTextField.text!.md5,  type: 0)) { (result) in
//                            switch result{
//                            case let .success(moyaResponse):
//                                let rootModel = RooteModel.init(jsonData: JSON.init(moyaResponse.data))
//                                if rootModel.code == RT_SUCCESS{
////                                    kRootVC = UIStoryboard.main
//                                }
//                            case .failure(_): break
//                            }
//                        }
//                    }
                case .failure(_): break
                }
            }
        case .resetPsd:
            provider.request(.resetPsd(phone: self.phone, token: self.token,  password: self.passwordTextField.text!.md5)) { (result) in
                switch result{
                case let .success(moyaResponse):break
//                    let rootModel = RooteModel.init(jsonData: JSON.init(moyaResponse.data))
//                    if rootModel.code == RT_SUCCESS{
//                        let hud1 = MBProgressHUD.showAdded(to: (kRootVC?.view)!, animated: true)
//                        hud1.mode = .text
//                        hud1.label.text = "重置成功"
//                        hud1.hide(animated: true, afterDelay: 1)
//                        self.navigationController?.popToRootViewController(animated: true)
//                    }
                case .failure(_): break
                }
            }
        }
        
    }
}
