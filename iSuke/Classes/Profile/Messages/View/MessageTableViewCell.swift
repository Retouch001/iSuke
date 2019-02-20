//
//  MessageTableViewCell.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/4.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var messageInfo: List? {
        didSet {
            guard let model = messageInfo else { return }
            titleLabel.text = model.msgTitle
            timeLabel.text = model.createTime
        }
    }
    


}
