//
//  TimeTaskTableViewCell.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/20.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class TimeTaskTableViewCell: UITableViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var repeatWeek: UILabel!
    @IBOutlet weak var swithTime: UISwitch!
    
    var switchClourse: ((_: Bool) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        swithTime.addTarget(self, action: #selector(ddd), for: .touchUpInside)
    }
    
    @objc func ddd() {
        print("Hello world")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func switchTimeChanged(_ sender: Any) {
        let currentSwitch = sender as! UISwitch
        switchClourse!(currentSwitch.isOn)
    }
    
    func freshCell(with timeTask: TimeTask) {
        time.text = timeTask.time
        if timeTask.status == 1 {
            swithTime.isOn = true
        }else{
            swithTime.isOn = false
        }
        if timeTask.execute == 1 {
            status.text = "开启设备"
        }else{
            status.text = "关闭设备"
        }
        repeatWeek.text = timeTask.weeksString()
    }
    
}
