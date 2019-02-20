//
//  DeviceCollectionViewCell.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/13.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class DeviceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var chooseImageView: UIImageView!
    
    
    var sceneCondition: SceneCondition! {
        didSet {
            icon.kf.setImage(with: URL(string: "\(DEV_URL)/\(sceneCondition.avatar!)"))
            deviceNameLabel.text = sceneCondition.name
            deviceNameLabel.textColor = UIColor.black
        }
    }
    
    
}
