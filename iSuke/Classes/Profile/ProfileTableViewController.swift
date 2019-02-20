//
//  ProfileTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/3.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileTableViewController: UITableViewController, NavigationBarSetProtocol {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topBgImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    public let topHeight = kScreenHeight/5.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView?.height = topHeight
        configureNavibar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if yOffset > -kTopBarHeight {
            navigationController?.navigationBar.setBackgroundImage(R.image.topbg(), for: .default)
        }else{
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
        
        if yOffset < 0 {
            let totalOffset = topHeight - 10 + abs(yOffset)
            let f = totalOffset/(topHeight-10)
            topBgImageView.frame = CGRect(x: -(kScreenWidth*f - kScreenWidth)/2, y: yOffset, width: kScreenWidth*f, height: totalOffset)
        }
    }
    
    private func updateUI() {
        iconImageView.kf.setImage(with: URL(string: (UserManager.share.loginUser?.avatar)!))
        phoneLabel.text = UserManager.share.loginUser?.phone
        nickNameLabel.text = UserManager.share.loginUser?.loginName?.count == 0 ? "未设置昵称" : (UserManager.share.loginUser?.loginName)!
    }
}

extension ProfileTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //super.tableView(tableView, didSelectRowAt: indexPath)
        if indexPath.section == 3 && indexPath.row == 1 {
            DebugTouchView.shared.setHid(hide: !DebugTouchView.shared.isHide())
            let window: UIWindow? = (UIApplication.shared.delegate?.window)!
            window?.bringSubview(toFront: DebugTouchView.shared)
        }
    }
}
