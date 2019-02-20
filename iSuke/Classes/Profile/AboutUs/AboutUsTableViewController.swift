//
//  AboutUsTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/6.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class AboutUsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Table view data source
extension AboutUsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            UIApplication.shared.openURL(URL(string:"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1142075299&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8" )!)
        case 2:
            UIApplication.shared.openURL(URL(string: "http://www.ibreezee.net")!)
        default:
            break
        }
    }
}
