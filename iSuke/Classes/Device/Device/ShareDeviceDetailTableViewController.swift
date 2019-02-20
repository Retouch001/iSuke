//
//  ShareDeviceDetailTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/23.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class ShareDeviceDetailTableViewController: UITableViewController {

    @IBOutlet weak var deviceAlias: UILabel!
    @IBOutlet weak var deviceShareUser: UILabel!
    
    var device: MyDevice! {
        didSet {
            if let label = deviceAlias, let tempDevice = device {
                label.text = tempDevice.alias
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceAlias.text = device.alias
        deviceShareUser.text = device.phone
        NotificationCenter.default.addObserver(self, selector: #selector(deviceAliasChanged(notification:)), name: .RTDeviceAliasChangedNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func deviceAliasChanged(notification: Notification) {
        let device = notification.object as? MyDevice
        self.device = device
    }
}

extension ShareDeviceDetailTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if R.segue.shareDeviceDetailTableViewController.shareDeviceDetailToDeviceSetAliasSegue(segue: segue) != nil {
            let deviceSetAliasVC = segue.destination as! DeviceSetAliasTableViewController
            deviceSetAliasVC.device = device
        }
        
        if R.segue.shareDeviceDetailTableViewController.shareDeviceDetailToDevicePowerSegue(segue: segue) != nil {
            let devicePowerVC = segue.destination as! DevicePowerBriefViewController
            devicePowerVC.device = device
        }
        
    }
}
