//
//  RegisterFillPNViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/24.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class RegisterFillPNViewController: UIViewController {

    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: HoshiTextField!
    @IBOutlet weak var nextActionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.addTarget(self, action: #selector(self.textFieldDidChanged(_ :)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChanged(_ textField: UITextField){
        if (phoneNumberTextField.text?.count)! > 0 {
            nextActionBtn.backgroundColor = UIColor.theme
            nextActionBtn.isEnabled = true
        }else{
            nextActionBtn.backgroundColor = UIColor.unableBtn
            nextActionBtn.isEnabled = false
        }
    }
    
    @IBAction func selectCountry(_ sender: UIButton) {
        let selectCountryVC = SelectCountryTableViewController()
        selectCountryVC.backClosure = { value in
            let array = value.components(separatedBy: " ")
            self.countryBtn.setTitle(array.first, for: .normal)
            self.countryCodeLabel.text = array.last
        }
        let nav = UINavigationController.init(rootViewController: selectCountryVC)
        nav.navigationBar.tintColor = UIColor.black
        present(nav, animated: true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let provider = MoyaProvider<MyService>(plugins: [MyNetworkLoggerPlugin()])
        provider.request(.verifyCode(phone: phoneNumberTextField.text!, countryCode:countryCodeLabel.text!)) { (result) in
            switch result{
            case let .success(moyaResponse): break
//                let rootModel = RooteModel.init(jsonData: JSON.init(moyaResponse.data))
//                if rootModel.code == RT_SUCCESS {
////                    let verifyCodeVC = UIStoryboard.verifyCode
////                    verifyCodeVC.phoneNumber = self.phoneNumberTextField.text!
////                    verifyCodeVC.countryCode = self.countryCodeLabel.text!
////                    verifyCodeVC.verifyType = .register
////                    self.navigationController?.pushViewController(verifyCodeVC, animated: true)
//                }
            case .failure(_): break
            }
        }
    }
}
