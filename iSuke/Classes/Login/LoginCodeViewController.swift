//
//  LoginCodeViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/27.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class LoginCodeViewController: UIViewController {
    var phoneNumber = ""
    var countryCode = ""
    var verifyType: VerifyType = .login
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var verifyCoceTextField: ZQCodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyCoceTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countryCodeLabel.text = countryCode
        phoneNumberLabel.text = phoneNumber
    }
}


extension LoginCodeViewController: RTCodeTextFieldDelegate{
    func codeView(_ inputString: String) {
        print(inputString)
        let provider = MoyaProvider<MyService>(plugins: [MyNetworkLoggerPlugin(), RequestLoadingPlugin()])
        provider.request(.checkVerifyCode(phone: phoneNumberLabel.text!, verifyCode:inputString)) { (result) in
            switch result{
            case let .success(moyaResponse): break
//                let rootModel = RooteModel.init(jsonData: JSON.init(moyaResponse.data))
//                if rootModel.code == RT_SUCCESS {
//                    switch self.verifyType{
//                    case .login:
//                        print("dd")
//                    case .resetPsd:
//                        print("dd")
//
////                        let registerVC = UIStoryboard.register
////                        registerVC.countryCode = self.countryCode
////                        registerVC.phone = self.phoneNumber
////                        registerVC.inputPsdType = .resetPsd
////                        let json = JSON(moyaResponse.data)
////                        registerVC.token = json["data"]["token"].stringValue
////                        self.navigationController?.pushViewController(registerVC, animated: true)
//                    case .register:
//                        print("dd")
//
////                        let registerVC = UIStoryboard.register
////                        registerVC.countryCode = self.countryCode
////                        registerVC.phone = self.phoneNumber
////                        registerVC.inputPsdType = .register
////                        let json = JSON(moyaResponse.data)
////                        registerVC.token = json["data"]["token"].stringValue
////                        self.navigationController?.pushViewController(registerVC, animated: true)
//                    }
//                }else{
//                    self.verifyCoceTextField.clear()
//                }
            case .failure(_): break
            }
        }
    }
}

