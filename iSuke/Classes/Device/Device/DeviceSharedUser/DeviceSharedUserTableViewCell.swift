//
//  DeviceSharedUserTableViewCell.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/19.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class DeviceSharedUserTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func freshCell(with shareUser: ShareUser) {
        if let iconUrl = shareUser.avatar {
            icon.kf.setImage(with: URL(string: iconUrl))
        }
        userName.text = shareUser.alias == nil ? shareUser.loginName : shareUser.alias
        userPhone.text = shareUser.phone
    }
}
