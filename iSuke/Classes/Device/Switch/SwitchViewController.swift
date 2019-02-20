//
//  SwitchViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/19.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController, NavigationBarSetProtocol {

    @IBOutlet weak var togBgImageView: UIImageView!
    @IBOutlet weak var mainSwitchBtn: UIButton!
    @IBOutlet weak var subSwitchBtn: UIButton!
    @IBOutlet weak var switchNameLabel: UILabel!
    @IBOutlet weak var switchStatusLabel: UILabel!
    @IBOutlet weak var editJackAliasBtn: UIButton!
    
    @IBOutlet weak var emptyPageView: UIView!
    
    var device: MyDevice!
    var subSwitch: Switch! {
        didSet {
            if subSwitch.status {
                togBgImageView.image = R.image.ic_topbg()
                mainSwitchBtn.setImage(R.image.ic_switch_on(), for: .normal)
                subSwitchBtn.setImage(R.image.ic_3random01(), for: .normal)
                switchStatusLabel.text = R.string.localizable.switch_ON()
                switchStatusLabel.textColor = UIColor.theme
            }else{
                togBgImageView.image = R.image.ic_topbg05()
                mainSwitchBtn.setImage(R.image.ic_switch_off(), for: .normal)
                subSwitchBtn.setImage(R.image.ic_3normal_random(), for: .normal)
                switchStatusLabel.text = R.string.localizable.switch_OFF()
                switchStatusLabel.textColor = UIColor.gray
            }
            switchNameLabel.text = subSwitch.alias
        }
    }
    var textF1 = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceAliasChanged(notification:)), name: .RTDeviceAliasChangedNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initView() {
        title = device?.alias
        configureNavibar()
        editJackAliasBtn.isHidden = device.typeName == nil
    }
    
    
    @IBAction func rightBarButtonTaped(_ sender: Any) {
        if device.phone != nil {
            let shareDeviceDetailVC = R.storyboard.device.shareDeviceDetailTableViewController()
            shareDeviceDetailVC?.device = device
            navigationController?.pushViewController(shareDeviceDetailVC!, animated: true)
        }else{
            let deviceDetailVC = R.storyboard.device.deviceDetailTableViewController()
            deviceDetailVC?.device = device
            navigationController?.pushViewController(deviceDetailVC!, animated: true)
        }
    }
    
    
    @IBAction func tapMainSwitch(_ sender: Any) {
        Network().request(target: MyService.modifySwitch(deviceNo: (self.device?.deviceNo)!, no: (self.subSwitch?.no)!, type: 0, alias: nil, on: !(self.subSwitch?.status)!), success: { [weak self] (dic) in
            self!.subSwitch.status = !(self!.subSwitch.status)
        })
    }
    
    @IBAction func tapSubSwitch(_ sender: Any) {
        Network().request(target: MyService.modifySwitch(deviceNo: (self.device?.deviceNo)!, no: self.subSwitch.no, type: 1, alias: nil, on: !(self.subSwitch.status)), success: { [weak self] (dic) in
            self!.subSwitch.status = !(self!.subSwitch.status)
        })
    }
    
    @IBAction func modifySwitchName(_ sender: Any) {
        let alertVC = UIAlertController(title: "设置备注", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            self.textF1 = textField
            self.textF1.clearButtonMode = .whileEditing
            self.textF1.font = UIFont.systemFont(ofSize: 15)
            self.textF1.placeholder = self.subSwitch?.alias
        }
        let confirmAction = UIAlertAction(title: R.string.localizable.confirM(), style: .default) { (action) in
            Network().request(target: MyService.modifySwitch(deviceNo: (self.device?.deviceNo)!, no: (self.subSwitch?.no)!, type: 2, alias: (self.textF1.text)!, on: (self.subSwitch?.status)!), success: { [weak self] (dic) in
                self?.subSwitch?.alias = self?.textF1.text
            })
        }
        confirmAction.setValue(UIColor.theme, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: R.string.localizable.canceL(), style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.theme, forKey: "titleTextColor")
        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    private func loadData() {
        if let deviceNo = device?.deviceNo {
            Network().request(target: MyService.deviceSwitch(deviceNo: deviceNo), success: { [weak self] (data) in
                let switches = [Switch].deserialize(from: data as? [Any])
                self?.subSwitch = switches?.first as? Switch
                self?.emptyPageView.removeFromSuperview()
            })
        }
    }
    
    @objc private func deviceAliasChanged(notification: Notification) {
        let device = notification.object as? MyDevice
        title = device?.alias
    }
}

extension SwitchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let deviceDetailVC = segue.destination as! DeviceDetailTableViewController
        deviceDetailVC.device = self.device
    }
}
