//
//  MessageDetailViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/11.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageInfoLabel: UILabel!
    
    var id: Int = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Network().request(target: MyService.msgDetial(id: id), success: { [weak self] (data) in
            //let strg: String = dic["content"] as! String
            let strg: String = (data as! [String: Any])["content"] as! String
            let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:strg)
            //行间距
            let paragraphStye = NSMutableParagraphStyle()
            paragraphStye.lineSpacing = 10
            //行间距的范围
            let distanceRange = NSMakeRange(0, CFStringGetLength(strg as CFString?))
            attrstring .addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStye, range: distanceRange)
            self?.messageInfoLabel.attributedText = attrstring//赋值方法
        })
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
