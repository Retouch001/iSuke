//
//  DeviceListViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/13.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

let identifier = "cell"

class DeviceListViewController: UIViewController, NavigationBarSetProtocol {
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (kScreenWidth-2*collectionMargin)/3, height: (kScreenWidth-2*collectionMargin)/3)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, collectionMargin, 0, collectionMargin)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()
    
    lazy var header: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.viewModel.loadData()
        })
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true
        return header!
    }()
    
    let viewModel = DeviceListViewModel()
    var isMultiple = false
    var selectedDevice = [MyDevice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavibar()
        initCollectionView()
        initViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceAliasChanged(notification:)), name: .RTDeviceAliasChangedNotification, object: nil)        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func editDeviceExecute(_ sender: UIButton) {
        isMultiple = !isMultiple
        if isMultiple {
            leftBarButton.title = "完成"
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(rightBarButtonExecute)), animated: true)
            navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            leftBarButton.title = "编辑"
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonExecute)), animated: true)
        }
        collectionView.reloadData()
    }
    
    @objc private func rightBarButtonExecute() {
        if isMultiple {
            let alertVC = UIAlertController(title: "确定删除？", message: "您确定删除所选中的所有设备吗？", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "确定", style: .default) { (UIAlertAciton) in
                var devicesNo: String = String()
                for device: MyDevice in self.selectedDevice {
                    devicesNo = devicesNo + "-\(device.deviceNo!)"
                }
                Network().request(target: MyService.delDevice(deviceNo:devicesNo), success: { (data) in
                    self.viewModel.loadData()
                })
            }
            actionOK.setValue(UIColor.theme, forKey: "titleTextColor")
            let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            actionCancel.setValue(UIColor.theme, forKey: "titleTextColor")
            alertVC.addAction(actionCancel)
            alertVC.addAction(actionOK)
            present(alertVC, animated: true, completion: nil)
        }else{
            let addDeviceVC = R.storyboard.device.deviceTypeSelectViewController()
            navigationController?.pushViewController(addDeviceVC!, animated: true)
        }
    }
    
    
    @objc private func deviceAliasChanged(notification: Notification) {
        viewModel.loadData()
    }
    
    private func initCollectionView() {
        collectionView.mj_header = header
        collectionView.allowsMultipleSelection = true
        collectionView.register(R.nib.deviceCollectionViewCell(), forCellWithReuseIdentifier: identifier)
        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.emptyDataSetSource = viewModel
        collectionView.emptyDataSetDelegate = viewModel
    }
    
    private func initViewModel() {
        viewModel.loadData()
        viewModel.reloadTableViewClosure = { [weak self] () in
            self?.collectionView.reloadData()
        }
        viewModel.updateLoadingStatus = { [weak self] () in
            self?.header.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
}

extension DeviceListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (viewModel.deviceGroup?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let devices = viewModel.deviceGroup![section]
        return devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DeviceCollectionViewCell
        let device = viewModel.deviceGroup![indexPath.section][indexPath.row]
        if let name = device.alias {
            cell.deviceNameLabel.text = name
        }else {
            cell.deviceNameLabel.text = device.deviceName
        }
        
        if isMultiple {
            let viewLayer: CALayer? = cell.layer
            let animation = CABasicAnimation(keyPath: "transform")
            animation.duration = 0.17
            animation.repeatCount = MAXFLOAT
            animation.autoreverses = true
            animation.fromValue = NSValue(caTransform3D: CATransform3DRotate((viewLayer?.transform)!, -0.03, 0.0, 0.0, 0.03))
            animation.toValue = NSValue(caTransform3D: CATransform3DRotate((viewLayer?.transform)!, 0.03, 0.0, 0.0, 0.03))
            viewLayer?.add(animation, forKey: "wiggle")
        }else{
            cell.chooseImageView.isHidden = true
            cell.backGroundView.alpha = 1
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: R.reuseIdentifier.deviceListCollectionReusableView, for: indexPath)
        let device = viewModel.deviceGroup![indexPath.section][indexPath.row]
        if device.typeName != nil {
            header?.titleLabel.text = R.string.localizable.my_DEVICE()
        }else{
            header?.titleLabel.text = R.string.localizable.shared_DEVICE()
        }
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: kScreenWidth, height: 30)
        }
        return CGSize(width: kScreenWidth, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMultiple {
            let cell = collectionView.cellForItem(at: indexPath) as! DeviceCollectionViewCell
            cell.chooseImageView.isHidden = false
            cell.backGroundView.alpha = 0.6
            let device = viewModel.deviceGroup![indexPath.section][indexPath.row]
            selectedDevice.append(device)
            navigationItem.rightBarButtonItem?.isEnabled = true

        }else{
            let device = viewModel.deviceGroup![indexPath.section][indexPath.row]
            let deviceDetailVC =  R.storyboard.device.switchViewController()
            deviceDetailVC?.device = device
            navigationController?.pushViewController(deviceDetailVC!, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DeviceCollectionViewCell
        cell.chooseImageView.isHidden = true
        cell.backGroundView.alpha = 1
       let device = viewModel.deviceGroup![indexPath.section][indexPath.row]
        selectedDevice = selectedDevice.filter({ (tempDevice) -> Bool in
            tempDevice.deviceNo != device.deviceNo
        })
        if selectedDevice.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
