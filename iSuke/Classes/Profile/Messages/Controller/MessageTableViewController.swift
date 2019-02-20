//
//  MessageTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/4.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {
    var message = Message()
    var loding = true
    
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
    }
    
    @objc private func loadData() {
        Network().request(target: MyService.msgList(pageNum: 0), success: { [weak self](data) in
            self?.header.endRefreshing()
            self?.loding = false
            self?.message = Message.deserialize(from: data as? [String: Any])!
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


// MARK: - Table view data source
extension MessageTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageTableViewCell.self), for: indexPath) as! MessageTableViewCell
        cell.messageInfo = message.list[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageDetailVC = R.storyboard.profile.messageDetailViewController()
        messageDetailVC?.id = message.list[indexPath.row].id
        navigationController?.pushViewController(messageDetailVC!, animated: true)
    }
}

//MARK: Empty DataSet Delegate
extension MessageTableViewController: DZNEmptyDataSetSource {
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if loding { return nil}
        let str = R.string.localizable.no_NOTIFICATION()
        let attr = NSMutableAttributedString(string:str)
        attr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, CFStringGetLength(str as CFString?)))
        return attr
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if loding { return R.image.ic_loading() }
        return R.image.ic_02nothing()
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
extension MessageTableViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return loding
    }
}



