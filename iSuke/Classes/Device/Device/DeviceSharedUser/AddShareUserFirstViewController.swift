//
//  AddShareUserFirstViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/19.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class AddShareUserFirstViewController: UIViewController {

    @IBOutlet weak var deviceTypeImageView: UIImageView!
    @IBOutlet weak var deviceAliasLabel: UILabel!
    
    @IBOutlet weak var shareUserPhoneLabel: HoshiTextField!
    @IBOutlet weak var confirmBtn: UIButton!

    var device: MyDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        deviceAliasLabel.text = device.alias
        shareUserPhoneLabel.addTarget(self, action: #selector(self.textFieldDidChanged(_ :)), for: .editingChanged)
    }
    
    @IBAction func confirmAciton(_ sender: Any) {
        Network().request(target: MyService.searchUser(phone: shareUserPhoneLabel.text!), success: { [weak self](data) in
            let willSharedUser = LoginUser.deserialize(from: data as? [String: Any])
            let addShareUserSecondVC = R.storyboard.device.addShareUserSecondViewController()
            addShareUserSecondVC?.device = self?.device
            addShareUserSecondVC?.willShareUser = willSharedUser
            guard willSharedUser != nil else { return }
            self?.navigationController?.pushViewController(addShareUserSecondVC!, animated: true)
        }) { (error) in
            
        }
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if (shareUserPhoneLabel.text?.count)! > 0 {
            confirmBtn.isEnabled = true
            confirmBtn.backgroundColor = UIColor.theme
        }else{
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = UIColor.unableBtn
        }
    }

}
