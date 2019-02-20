//
//  TabBarViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/4.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        tabBar.shadowImage = UIImage()
//        tabBar.backgroundImage = UIImage()
//        tabBar.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
