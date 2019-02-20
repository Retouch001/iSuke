//
//  SelectWeekTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/20.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class SelectWeekTableViewController: UITableViewController {

    var weeksChangedClourse: ((_ timeTask: TimeTask) -> ())?

    var timeTask = TimeTask()
    
    let weeks = ["每周一", "每周二", "每周三", "每周四", "每周五", "每周六", "每周日"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        weeksChangedClourse!(timeTask)
    }
}

extension SelectWeekTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectWeekCell, for: indexPath)
        cell?.textLabel?.text = weeks[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell?.accessoryView = timeTask.mon == 1 ? UIImageView(image: R.image.icCheck()) : UIView()
        case 1:
            cell?.accessoryView = timeTask.tue == 1 ? UIImageView(image: R.image.icCheck()) : UIView()
        case 2:
            cell?.accessoryView = timeTask.wed == 1 ? UIImageView(image: R.image.icCheck()) : UIView()
        case 3:
            cell?.accessoryView = timeTask.thur == 1 ? UIImageView(image: R.image.icCheck()) : UIView()
        case 4:
            cell?.accessoryView = timeTask.fri == 1 ? UIImageView(image: R.image.icCheck()) : UIView()
        case 5:
            cell?.accessoryView = timeTask.sat == 1 ? UIImageView(image: R.image.icCheck()) : UIView()
        case 6:
            cell?.accessoryView = timeTask.sun == 1 ? UIImageView(image: R.image.icCheck()) : UIView()
        default:break
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            timeTask.mon == 1 ? (timeTask.mon = 0) : (timeTask.mon = 1)
        case 1:
            timeTask.tue == 1 ? (timeTask.tue = 0) : (timeTask.tue = 1)
        case 2:
            timeTask.wed == 1 ? (timeTask.wed = 0) : (timeTask.wed = 1)
        case 3:
            timeTask.thur == 1 ? (timeTask.thur = 0) : (timeTask.thur = 1)
        case 4:
            timeTask.fri == 1 ? (timeTask.fri = 0) : (timeTask.fri = 1)
        case 5:
            timeTask.sat == 1 ? (timeTask.sat = 0) : (timeTask.sat = 1)
        case 6:
            timeTask.sun == 1 ? (timeTask.sun = 0) : (timeTask.sun = 1)
        default:break
        }
        tableView.reloadData()
    }
}

