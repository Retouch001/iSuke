//
//  LoginViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/27.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import Moya

class LoginViewController: UIViewController {

    @IBOutlet weak var PNTextField: HoshiTextField!
    @IBOutlet weak var PSDTextField: HoshiTextField!
    @IBOutlet weak var LoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHideNavigationBar()
                
        PNTextField.addTarget(self, action: #selector(self.textFieldDidChanged(_ :)), for: .editingChanged)
        PSDTextField.addTarget(self, action: #selector(self.textFieldDidChanged(_ :)), for: .editingChanged)
    }
    
    private func configureHideNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func login(_ sender: Any) {
        Network().request(target: MyService.login(phone: PNTextField.text!, val:PSDTextField.text!.md5,  type: 0), success: { (data) in
            let loginUser = LoginUser.deserialize(from: data as? [String: Any])
            UserManager.share.loginUser = loginUser
            UserManager.saveLoginUser(loginUser: loginUser!)
            kRootVC = UIStoryboard(storyboard: .main).instantiateInitialViewController()
        }, fail: nil)
    }
    
    @IBAction func skipToPnLogin(_ sender: Any) {
        
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {

    }
}

// :MARK--
extension LoginViewController {
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
