//
//  DeviceListViewModel.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/13.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

enum EmptyPage {
    case firstLoading
    case noData
    case noNetwork
}

class DeviceListViewModel: NSObject {
    
    typealias CommonCompletion = () -> ()
    
    var reloadTableViewClosure: CommonCompletion?
    var updateLoadingStatus: CommonCompletion?
    
    //MARK: control TableView
    var deviceGroup: [[MyDevice]]? = Array() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    //MARK: control CollectionView
    var scenes = [Scene]() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    
    //MARK: control DZEmptyView
    var emptyPage: EmptyPage = .firstLoading

    var isEndRefreshing: Bool = false {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    @objc func loadData() {
        Network().request(target: MyService.getDeviceList, success: {[weak self] (data) in
            let device = Device.deserialize(from: data as? [String: Any])
            self?.deviceGroup?.removeAll()
            self?.deviceGroup?.append((device?.myDevices)!)
            self?.deviceGroup?.append((device?.sharedDevices)!)
            self?.emptyPage = .noData
            self?.isEndRefreshing = true
        }) {[weak self] (error) in
            self?.emptyPage = .noNetwork
            self?.isEndRefreshing = true
        }
    }
    
    @objc func loadSceneData() {
        Network().request(target: MyService.getScenes, success: {[weak self] (data) in
            self?.scenes = [Scene].deserialize(from: data as? [Any])! as! [Scene]
            self?.emptyPage = .noData
            self?.isEndRefreshing = true
        }) {[weak self] (error) in
            self?.emptyPage = .noNetwork
            self?.isEndRefreshing = true
        }
    }
}

extension DeviceListViewModel: DZNEmptyDataSetSource {
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var str: String!
        switch emptyPage {
        case .firstLoading:
            return nil
        case .noData:
            str = R.string.localizable.add_DEVICE()
        case .noNetwork:
            str = R.string.localizable.no_NETWORK()
        }
        let attr = NSMutableAttributedString(string:str)
        attr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, CFStringGetLength(str as CFString?)))
        return attr
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        switch emptyPage {
        case .firstLoading:
            return R.image.ic_loading()
        case .noData:
            return R.image.ic_01nothing()
        case .noNetwork:
            return R.image.ic_01nothing()
        }
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi/2), 0.0, 0.0, 1.0))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.isRemovedOnCompletion = false
        animation.repeatCount = MAXFLOAT
        return animation
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        if emptyPage == .firstLoading { return nil }
        return R.image.ic_addequipment1()
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.base1
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        if emptyPage == .firstLoading { return true }
        return false
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        if emptyPage == .firstLoading { return false }
        return true
    }
}

extension DeviceListViewModel: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        print("Hello man")
    }
}
