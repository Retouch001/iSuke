//
//  DeviceConfigFirstViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/22.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import SwiftMessages

class DeviceConfigFirstViewController: UIViewController {

    @IBOutlet weak var indicatorLight: UIImageView!
    @IBOutlet weak var configProgressLabel: UILabel!
    @IBOutlet weak var configProgress: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var userName: String?
    var password: String?

    lazy var timer: Timer = {
        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(repeatExecute), userInfo: nil, repeats: true)
        return timer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        timer.fire()
    }
    
    
    @objc private func repeatExecute() {
        indicatorLight.image == R.image.ic_promptflash01() ? (indicatorLight.image = R.image.ic_promptflash02()) : (indicatorLight.image = R.image.ic_promptflash01())
    }

    @IBAction func confirmExecute(_ sender: Any) {        
        let view1: WiFiInfoView = try! SwiftMessages.viewFromNib()
        view1.confirmClosure = { [weak self](username1, password1) in
            self?.userName = username1
            self?.password = password1
            let deviceConfigSecondVC = R.storyboard.deviceConfig.deviceConfigSecondViewController()
            self?.navigationController?.pushViewController(deviceConfigSecondVC!, animated: true)
        }
        
//        view1.configureDropShadow()
//        view1.backgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
//        view1.backgroundView.layer.shadowRadius = 50
        
        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        SwiftMessages.show(config: config, view: view1)
    }
}
