//
//  TimeTaskTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/20.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class TimeTaskTableViewController: UITableViewController {
    var loding = true
    var device = MyDevice()
    var timeTasks: [TimeTask]! = [TimeTask]() {
        didSet {
            //tableView.reloadData()
        }
    }
    
    lazy var header = { () -> MJRefreshNormalHeader in
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        header?.activityIndicatorViewStyle = .gray
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true
        return header!
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.mj_header = header
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .RTTimeTaskAddFinishedNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func loadData() {
        Network().request(target: MyService.searchTimeTask, success: { [weak self](data) in
            self?.timeTasks = ([TimeTask].deserialize(from: data as? [Any])) as? [TimeTask]
            self?.header.endRefreshing()
            self?.loding = false
            self?.tableView.reloadData()
        }) { [weak self](error) in
            self?.loding = false
            self?.header.endRefreshing()
            self?.tableView.reloadData()
        }
    }
}


// MARK: - Table view data source
extension TimeTaskTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.timeTaskTableViewCell, for: indexPath)
        var timeTask = timeTasks[indexPath.row]
        cell?.switchClourse = { (status) in
            status ? (timeTask.status = 1) : (timeTask.status = 0)
            Network().request(target: MyService.operateTimeTask(timerId: timeTask.timerId!, type: timeTask.status), success: {[weak self] (data) in
                self?.loadData()
                }, fail: { [weak self](error) in
                    self?.loadData()
            })
        }
        cell?.freshCell(with: timeTask)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let timerTask = timeTasks[indexPath.row]
        let editAction = UITableViewRowAction(style: .default, title: "编辑") { (action, indexpath) in
            let editTimeTaskNav = R.storyboard.device.addTimeTaskNavigationCotroller()
            let editTimeTaskVC = editTimeTaskNav?.rt_topViewController as! AddTimeTaskTableViewController
            editTimeTaskVC.device = self.device
            editTimeTaskVC.timeTask = timerTask
            self.present(editTimeTaskNav!, animated: true, completion: nil)
        }
        let deleteAction = UITableViewRowAction(style: .default, title: "删除") { (action, indexpath) in
            Network().request(target: MyService.operateTimeTask(timerId: timerTask.timerId!, type: 2), success: { (data) in
                self.timeTasks.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                if self.timeTasks.count == 0 {
                    self.tableView.reloadData()
                }
            })
        }
        editAction.backgroundColor = UIColor.theme
        return [deleteAction, editAction]
    }
}

extension TimeTaskTableViewController: DZNEmptyDataSetSource {
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if loding { return nil}
        let str = R.string.localizable.notimetasK()
        let attr = NSMutableAttributedString(string:str)
        attr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, CFStringGetLength(str as CFString?)))
        return attr
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if loding { return R.image.ic_loading() }
        return R.image.ic_06nothing()
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi/2), 0.0, 0.0, 1.0))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        return animation
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -kStatusBarHeight
    }
}

//MARK: DZNEmptyDataSetDelegate
extension TimeTaskTableViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return loding
    }
}

extension TimeTaskTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addTimeTaskNav = (segue.destination as! RTRootNavigationController)
        let addTimeTaskVC = addTimeTaskNav.rt_topViewController as! AddTimeTaskTableViewController
        addTimeTaskVC.device = device
    }
}
