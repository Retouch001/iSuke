//
//  DebugTouchView.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/14.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

let DEBUGTOUCHVIEW_STATUS_KEY = "DEBUGTOUCHVIEW_STATUS_KEY"

class DebugTouchView: UIImageView {
    var isAnimated = false
    var startPoint = CGPoint.zero    
    
    static let shared = DebugTouchView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initParams()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initParams()
    }
    
    private func initParams() {
        image = R.image.assistivetouch()
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        height = 65
        width = 65
        x = kScreenWidth - width - 20
        y = 84
        isHidden = isHide()
    }
    
    @objc private func tapAction() {
        let alertVC = UIAlertController(title: "当前环境：开发环境", message: "您确定切换环境？程序将会闪退⚡️⚡️⚡️⚡️", preferredStyle: .actionSheet)
        let developAction = UIAlertAction(title: "开发环境", style: .default, handler: { (action) in

        })
        developAction.setValue(UIColor.theme, forKey: "titleTextColor")

        let testAction = UIAlertAction(title: "测试环境", style: .default, handler: { (action) in

        })
        testAction.setValue(UIColor.theme, forKey: "titleTextColor")

        let distributionAction = UIAlertAction(title: "客户环境", style: .default, handler: { (action) in

        })
        distributionAction.setValue(UIColor.theme, forKey: "titleTextColor")

        let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancleAction.setValue(UIColor.gray, forKey: "titleTextColor")

        alertVC.addAction(developAction)
        alertVC.addAction(testAction)
        alertVC.addAction(distributionAction)
        alertVC.addAction(cancleAction)
        kRootVC?.present(alertVC, animated: true, completion: nil)
    }
    
    func isHide() -> Bool {
        if let hide = UserDefaults.standard.object(forKey: DEBUGTOUCHVIEW_STATUS_KEY) {
            return hide as! Bool
        }
        return false
    }
    
    func setHid(hide: Bool) {
        if isAnimated { return }
        UserDefaults.standard.set(hide, forKey: DEBUGTOUCHVIEW_STATUS_KEY)
        UserDefaults.standard.synchronize()
        hide ? close() : open()
    }
    
    
    private func close() {
        isUserInteractionEnabled = false
        isAnimated = true
        isHidden = false
        
        transform = CGAffineTransform.identity
        transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { finished in
            self.transform = CGAffineTransform.identity
            self.isUserInteractionEnabled = true
            self.isAnimated = false
        }
    }
    
    private func open() {
        isUserInteractionEnabled = false
        isAnimated = true
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { finished in
            self.transform = CGAffineTransform.identity
            self.isHidden = true
            self.isUserInteractionEnabled = true
            self.isAnimated = false
        }
    }
}

extension DebugTouchView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        let point = touch.location(in:self)     //获取当前点击位置
        self.startPoint = point;
        superview?.bringSubview(toFront: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let point = touch.location(in: self)
        let dx = point.x - startPoint.x
        let dy = point.y - startPoint.y
    
        var newCenter = CGPoint(x: center.x + dx, y: center.y + dy)
        let halfx = bounds.midX
        newCenter.x = max(halfx, newCenter.x)
        newCenter.x = min((superview?.bounds.size.width)! - halfx, newCenter.x)
        
        let halfy = bounds.midY
        newCenter.y = max(halfy, newCenter.y)
        newCenter.y = min((superview?.bounds.size.height)! - halfy, newCenter.y)
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.center = newCenter
        }, completion: nil)
    }
}
