//
//  DeviceDetailTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/19.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class DeviceDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var deviceAliasLabel: UILabel!
    
    var device: MyDevice! {
        didSet {
            if let label = deviceAliasLabel,let tempDevice = device {
                label.text = tempDevice.alias
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceAliasLabel.text = device.alias
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

extension DeviceDetailTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 4 {
            let alertVC = UIAlertController(title: "删除设备？", message: "设备删除后您将需要重新绑定才能再次使用该设备", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "确定", style: .default) { (UIAlertAciton) in
                Network().request(target: MyService.delDevice(deviceNo: self.device.deviceNo!), success: { [weak self](data) in
                    self?.rt_navigationController.popToRootViewController(animated: true, complete: nil)
                })
            }
            actionOK.setValue(UIColor.theme, forKey: "titleTextColor")
            let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            actionCancel.setValue(UIColor.theme, forKey: "titleTextColor")
            alertVC.addAction(actionCancel)
            alertVC.addAction(actionOK)
            present(alertVC, animated: true, completion: nil)
        }else if indexPath.section == 3 {
            let feedbackVC = R.storyboard.profile.feedBack()
            navigationController?.pushViewController(feedbackVC!, animated: true)
        }else if indexPath.section == 2 && indexPath.row == 1 {
            let configDeviceVC = R.storyboard.deviceConfig.deviceConfigFirstViewController()
            navigationController?.pushViewController(configDeviceVC!, animated: true)
        }
    }
}

extension DeviceDetailTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if R.segue.deviceDetailTableViewController.deviceDetailToDeviceSetAliasSegue(segue: segue) != nil {
            let deviceSetAliasVC = segue.destination as! DeviceSetAliasTableViewController
            deviceSetAliasVC.device = device
        }
        
        if R.segue.deviceDetailTableViewController.deviceDetailToDeviceSharedUserSegue(segue: segue) != nil {
            let devieSharedUserVC = segue.destination as! DeviceSharedUserTableViewController
            devieSharedUserVC.device = device
            
        }
        
        if R.segue.deviceDetailTableViewController.deviceDetailToDevicePowerSegue(segue: segue) != nil {
            let devicePowerVC = segue.destination as! DevicePowerBriefViewController
            devicePowerVC.device = device
        }
        
        if R.segue.deviceDetailTableViewController.deviceDetailToTimeTaskSegue(segue: segue) != nil {
            let timeTaskVC = segue.destination as! TimeTaskTableViewController
            timeTaskVC.device = device
        }
    }
}
