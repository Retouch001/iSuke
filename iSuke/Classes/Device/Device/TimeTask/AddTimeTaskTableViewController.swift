//
//  AddTimeTaskTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/20.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class AddTimeTaskTableViewController: UITableViewController {

    var timeTask: TimeTask = TimeTask()
    var device = MyDevice()
    
    
    let pickerDataSize = 160000
    lazy var hours: [String] = {
        var tempHours = [String]()
        for str in 0...23 {
            tempHours.append(String(str))
        }
        return tempHours
    }()
    
    lazy var minutes: [String] = {
        var tempMinutes = [String]()
        for str in 0...59 {
            tempMinutes.append(String(format: "%02d", str))
        }
        return tempMinutes
    }()
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var repeatWeek: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        freshUI()
        initData()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        Network().request(target: MyService.editTimeTask(timeTask: timeTask), success:  { (data) in
            NotificationCenter.default.post(name: .RTTimeTaskAddFinishedNotification, object: nil)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func freshUI() {
        if timeTask.deviceId != nil {
            let time = timeTask.time?.components(separatedBy: ":")
            let hour = Int((time?.first)!)
            let minute = Int((time?.last)!)
            pickerView.selectRow(hour! + 24*100, inComponent: 0, animated: false)
            pickerView.selectRow(minute! + 60*100, inComponent: 1, animated: false)
            repeatWeek.text = timeTask.weeksString()
            status.text = timeTask.execute == 0 ? "关闭设备" : "开启设备"
        }else{
            pickerView.selectRow(12 + 12*100, inComponent: 0, animated: false)
            pickerView.selectRow(0 + 60*100, inComponent: 1, animated: false)
            repeatWeek.text = "永不"
            status.text = "关闭设备"
        }
    }
    
    private func initData() {
        if timeTask.deviceId == nil {
            timeTask.time = "12:00"
            timeTask.deviceId = device.deviceId
            timeTask.status = 1
        }
    }
    
}

extension AddTimeTaskTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let openAction = UIAlertAction(title: "开启设备", style: .default) { (action) in
            self.timeTask.execute = 1
            self.freshUI()
        }
        let closeAction = UIAlertAction(title: "关闭设备", style: .default) { (action) in
            self.timeTask.execute = 0
            self.freshUI()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        openAction.setValue(UIColor.theme, forKey: "titleTextColor")
        closeAction.setValue(UIColor.theme, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")
        alertVC.addAction(openAction)
        alertVC.addAction(closeAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
}


extension AddTimeTaskTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSize
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .center
        label.textColor = UIColor.black;
        label.font = UIFont.systemFont(ofSize: 24)// 用label来设置字体大小
        label.backgroundColor = UIColor.clear
        if component == 0 {
            label.text = hours[row%hours.count]
        }else{
            label.text = minutes[row%minutes.count]
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hourRow = pickerView.selectedRow(inComponent: 0)
        let minuteRow = pickerView.selectedRow(inComponent: 1)
        let hour = hours[hourRow%hours.count]
        let minute = minutes[minuteRow%minutes.count]
        timeTask.time = "\(hour):\(minute)"
    }
}

extension AddTimeTaskTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectWeekVC = segue.destination as! SelectWeekTableViewController
        selectWeekVC.weeksChangedClourse = {[weak self] (timeTask) in
            self?.timeTask = timeTask
            self?.freshUI()
        }
        selectWeekVC.timeTask = timeTask
    }
}
