//
//  DeviceSetAliasTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/19.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class DeviceSetAliasTableViewController: UITableViewController {
    
    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var confirmBarBtn: UIBarButtonItem!
    var device: MyDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aliasTextField.placeholder = device.alias
        aliasTextField.addTarget(self, action: #selector(self.textFieldDidChanged(_ :)), for: .editingChanged)
    }
    
    @IBAction func modifyDeviceAlias(_ sender: Any) {
        if device.phone != nil {
            Network().request(target: MyService.setShareDeviceAlias(deviceNo: device.deviceNo!, alias: aliasTextField.text!), success:  { [weak self] (dic) in
                self?.device.alias = self?.aliasTextField.text
                NotificationCenter.default.post(name: .RTDeviceAliasChangedNotification, object: self?.device)
                self?.navigationController?.popViewController(animated: true)
            })
        }else{
            Network().request(target: MyService.modifyDevice(deviceNo: device.deviceNo!, alias: aliasTextField.text!), success:  { [weak self] (dic) in
                self?.device.alias = self?.aliasTextField.text
                NotificationCenter.default.post(name: .RTDeviceAliasChangedNotification, object: self?.device)
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if textField.text?.count == 0 || (textField.text == device.alias) {
            confirmBarBtn.isEnabled = false
        }else{
            confirmBarBtn.isEnabled = true
        }
    }
}
