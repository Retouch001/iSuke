//
//  SceneCollectionViewCell.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/23.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class SceneCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var isSeleected = false{
        didSet{
            if isSeleected {
                bgView.alpha = 0.6
                selectedImageView.isHidden = false
            }else{
                bgView.alpha = 1
                selectedImageView.isHidden = true
            }
        }
    }
    var isEditing = false{
        didSet{
            if isEditing {
                let animation = CABasicAnimation(keyPath: "transform")
                animation.duration = 0.17
                animation.repeatCount = MAXFLOAT
                animation.autoreverses = true
                animation.fromValue = NSValue(caTransform3D: CATransform3DRotate(layer.transform, -0.03, 0.0, 0.0, 0.03))
                animation.toValue = NSValue(caTransform3D: CATransform3DRotate(layer.transform, 0.03, 0.0, 0.0, 0.03))
                layer.add(animation, forKey: "shake")
                
            }else{
                layer.removeAnimation(forKey: "shake")
                bgView.alpha = 1
                selectedImageView.isHidden = true
            }
        }
    }
    var scene: Scene = Scene(){
        didSet {
            if scene.openStatus == 0 {
                statusLabel.text = "未开启"
                statusLabel.textColor = UIColor.lightGray
            }else{
                statusLabel.text = "执行中"
                statusLabel.textColor = UIColor.theme
            }
            titleLabel.text = scene.name
        }
    }
}
