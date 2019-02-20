//
//  AddShareUserSecondViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/19.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class AddShareUserSecondViewController: UIViewController {

    @IBOutlet weak var deviceIcon: UIImageView!
    @IBOutlet weak var deviceName: UILabel!
    
    @IBOutlet weak var willShareUserIcon: UIImageView!
    @IBOutlet weak var willShareUserName: UILabel!
    
    var device: MyDevice!
    var willShareUser: LoginUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceName.text = device.alias == nil ? device.deviceName : device.alias
        if let iconStr = willShareUser.avatar {
            willShareUserIcon.kf.setImage(with: URL(string: iconStr))
        }
        willShareUserName.text = willShareUser.loginName
    }

    @IBAction func addShareUser(_ sender: Any) {
        Network().request(target: MyService.shareDevice(deviceNo: device.deviceNo!, phone: willShareUser.phone!), success:  {[weak self] (data) in
            self?.navigationController?.popToViewController((self?.navigationController!.viewControllers[3])!, animated: true)
            NotificationCenter.default.post(name: .RTAddShareUserFinishedNotification, object: nil)
        })
        

    }
}
