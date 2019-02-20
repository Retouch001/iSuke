//
//  WiFiInfoView.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/22.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import SwiftMessages

class WiFiInfoView: UIView {
    
    var confirmClosure: ((_ : String, _ : String) -> ())?
    
    @IBOutlet weak var usernameTf: HoshiTextField!
    @IBOutlet weak var passwordTf: HoshiTextField!
    
    @IBAction func confirmExecute(_ sender: UIButton) {
        SwiftMessages.hide()
        if let confirmClosureExist = confirmClosure {
            confirmClosureExist(usernameTf.text!, passwordTf.text!)
        }
    }
    @IBAction func close(_ sender: Any) {
        SwiftMessages.hide()
    }
}
