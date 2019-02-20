//
//  DeviceSharedUserTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/19.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class DeviceSharedUserTableViewController: UITableViewController {

    var device: MyDevice!
    var loding = true
    var textF1 = UITextField()
    var shareUsers: [ShareUser]? {
        didSet {
            self.tableView.reloadData()
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
        configTableView()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .RTAddShareUserFinishedNotification, object: nil)
    }
    
    @objc private func loadData() {
        Network().request(target: MyService.sharedUser(deviceNo: device.deviceNo!), success: { [weak self](data) in
            self?.shareUsers = [ShareUser].deserialize(from: data as? [Any]) as? [ShareUser]
            self?.header.endRefreshing()
            self?.loding = false
            self?.tableView.reloadData()
        }) { [weak self](error) in
            self?.loding = false
            self?.header.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    private func configTableView() {
        tableView.mj_header = header
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
}

extension DeviceSharedUserTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareUsers?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.deviceSharedUserTableViewCell, for: indexPath)        
        let shareUser = shareUsers![indexPath.row]
        cell?.freshCell(with: shareUser)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareUser = shareUsers![indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: R.string.localizable.deletE()) { (action, indexPath) in
            Network().request(target: MyService.delShareDevice(deviceNo: self.device.deviceNo!, phone: shareUser.phone!), success: { (data) in
                self.shareUsers?.remove(at: indexPath.row)
            })
        }
        let remarkAction = UITableViewRowAction(style: .default, title: R.string.localizable.remarK()) { (action, indexPath) in
            let alertVC = UIAlertController(title: R.string.localizable.set_REMARK(), message: nil, preferredStyle: .alert)
            alertVC.addTextField { (textField) in
                self.textF1 = textField
                self.textF1.clearButtonMode = .whileEditing
                self.textF1.font = UIFont.systemFont(ofSize: 15)
                self.textF1.placeholder = shareUser.alias
            }
            let confirmAction = UIAlertAction(title: R.string.localizable.confirM(), style: .default) { (action) in
                Network().request(target: MyService.setShareUserAlias(phone: shareUser.phone!, alias: self.textF1.text!), success: { (data) in
                    self.loadData()
                })
            }
            confirmAction.setValue(UIColor.theme, forKey: "titleTextColor")
            let cancelAction = UIAlertAction(title: R.string.localizable.canceL(), style: .cancel, handler: nil)
            cancelAction.setValue(UIColor.theme, forKey: "titleTextColor")
            alertVC.addAction(confirmAction)
            alertVC.addAction(cancelAction)
            self.present(alertVC, animated: true, completion: nil)
        }
        remarkAction.backgroundColor = UIColor.theme
        return [deleteAction, remarkAction]
    }
}

extension DeviceSharedUserTableViewController: DZNEmptyDataSetSource {
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if loding { return nil}
        let str = R.string.localizable.no_SHAREDUSER()
        let attr = NSMutableAttributedString(string:str)
        attr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, CFStringGetLength(str as CFString?)))
        return attr
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if loding { return R.image.ic_loading() }
        return R.image.ic_04nothing()
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
extension DeviceSharedUserTableViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return loding
    }
}

extension DeviceSharedUserTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addShareUserFirstVC = segue.destination as! AddShareUserFirstViewController
        addShareUserFirstVC.device = device
    }
}

