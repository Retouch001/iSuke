//
//  DevicePowerDetailViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/20.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class DevicePowerDetailViewController: UIViewController, NavigationBarSetProtocol{

    @IBOutlet weak var totalPower: UILabel!
    
    var historyPower: HistoryPower!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavibar()
        
        totalPower.text = String(historyPower.total)
        title = "\(String((historyPower.date?.suffix(2))!))月"
    }

}
