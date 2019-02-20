//
//  LoginCheckPhoneViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/27.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class LoginCheckPhoneViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var countryNameBtn: UIButton!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneTextField: HoshiTextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    var checkPhoneType: CheckPhoneType = .register
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.addTarget(self, action: #selector(self.textFieldDidChanged(_ :)), for: .editingChanged)
    }
    

    private func setUI() {
        switch checkPhoneType {
        case .register:
            titleLabel.text = "注册iSuke账号"
            titleDescriptionLabel.isHidden = true
        case .resetPsd:
            titleLabel.text = "手机验证"
            titleDescriptionLabel.isHidden = false
        }
    }
    
    @objc private func textFieldDidChanged(_ textField: UITextField){
        if (phoneTextField.text?.count)! > 0 {
            nextBtn.backgroundColor = UIColor.theme
            nextBtn.isEnabled = true
        }else{
            nextBtn.backgroundColor = UIColor.unableBtn
            nextBtn.isEnabled = false
        }
    }
    
    @IBAction func selectCountry(_ sender: UIButton) {
        let selectCountryVC = SelectCountryTableViewController()
        selectCountryVC.backClosure = { value in
            let array = value.components(separatedBy: " ")
            self.countryNameBtn.setTitle(array.first, for: .normal)
            self.countryCodeLabel.text = array.last
        }
        let nav = UINavigationController.init(rootViewController: selectCountryVC)
        nav.navigationBar.tintColor = UIColor.black
        present(nav, animated: true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let provider = MoyaProvider<MyService>(plugins: [MyNetworkLoggerPlugin()])
        provider.request(.verifyCode(phone: phoneTextField.text!, countryCode:countryCodeLabel.text!)) { (result) in
            switch result{
            case let .success(moyaResponse): break
//                let rootModel = RooteModel.init(jsonData: JSON.init(moyaResponse.data))
//                if rootModel.code == RT_SUCCESS {
////                    let verifyCodeVC = UIStoryboard.verifyCode
////                    verifyCodeVC.phoneNumber = self.phoneTextField.text!
////                    verifyCodeVC.countryCode = self.countryCodeLabel.text!
////                    verifyCodeVC.verifyType = .register
////                    self.navigationController?.pushViewController(verifyCodeVC, animated: true)
//                }
            case .failure(_): break
            }
        }
    }
}
