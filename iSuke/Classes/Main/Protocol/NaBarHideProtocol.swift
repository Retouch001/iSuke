//
//  NavigationBarSetProtocol.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/17.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation

protocol NavigationBarSetProtocol {
    func configureNavibar()
}

extension NavigationBarSetProtocol where Self: UIViewController {
    func configureNavibar() {
        //MARK: cofigureNavigationBar
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
