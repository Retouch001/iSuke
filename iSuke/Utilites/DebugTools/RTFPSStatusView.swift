//
//  RTFPSStatusView.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/15.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class RTFPSStatusView: UILabel {
    static let shared = RTFPSStatusView()
    
    var lastTime: TimeInterval = 0
    var count: Int  = 0
    
    var displayLink: CADisplayLink {
        let link = CADisplayLink(target: self, selector: #selector(displayLinkTick(link:)))
        link.isPaused = true
        link.add(to: RunLoop.current, forMode: .commonModes)
        return link
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 12)
        textColor = UIColor.green
        backgroundColor = UIColor.clear
        textAlignment = .right
        tag = 11234
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActiveNotification), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    convenience init() {
        self.init(frame: CGRect(x: kScreenWidth - 60, y: kStatusBarHeight-10, width: 50, height: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        displayLink.isPaused = true
        displayLink.remove(from: RunLoop.current, forMode: .commonModes)
    }
    
    @objc private func applicationDidBecomeActiveNotification() {
        displayLink.isPaused = false
    }
    
    @objc private func applicationWillResignActiveNotification() {
        displayLink.isPaused = true
    }
    
    @objc private func displayLinkTick(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        
        count += 1
        let interval = link.timestamp - lastTime
        if interval < 1 {return}
        lastTime = link.timestamp
        let fps = count/Int(interval)
        count = 0
        
        text = "\(Int(round(Double(fps)))) FPS"
    }
    
    func open(in view: UIView?) {
        displayLink.isPaused = false
        if let currentView = view {
            for lable in (view?.subviews)! {
                if (lable is UILabel) && lable.tag == 11234 {
                    return
                }
            }
            center = currentView.center
            currentView.addSubview(self)
        } else {
            let rootVCViewSubViews = UIApplication.shared.delegate?.window??.rootViewController?.view.subviews
            for label: UIView in rootVCViewSubViews! {
                if (label is UILabel) && label.tag == 11234 {
                    return
                }
            }
            displayLink.isPaused = false
            (((UIApplication.shared.delegate) as? (NSObject & UIApplicationDelegate))?.window??.rootViewController?.view)?.addSubview(self)
        }
    }
    
    func close() {
        displayLink.isPaused = true
        
        let rootVCViewSubViews = UIApplication.shared.delegate?.window??.rootViewController?.view.subviews
        for label: UIView in rootVCViewSubViews! {
            if (label is UILabel) && label.tag == 11234 {
                label.removeFromSuperview()
                return
            }
        }
    }
}









