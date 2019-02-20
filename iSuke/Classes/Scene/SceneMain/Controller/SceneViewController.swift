//
//  SceneListViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/13.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

let sceneCellIdentifier = "sceneCellIdentifier"

class SceneViewController: UIViewController, NavigationBarSetProtocol {
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var isMultiple: Bool = false {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let viewModel = DeviceListViewModel()
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (kScreenWidth-2*collectionMargin)/2, height: (kScreenWidth-2*collectionMargin)/2)
        flowLayout.sectionInset = UIEdgeInsetsMake(collectionMargin, collectionMargin, 0, collectionMargin)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }
    
    lazy var header: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.viewModel.loadSceneData()
        })
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true
        return header!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        initViewModel()
        configureNavibar()
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonExecute))
    }
    
    @IBAction func editExecute(_ sender: UIBarButtonItem) {
        isMultiple = !isMultiple
        if isMultiple {
            editBarButton.title = "完成"
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(rightBarButtonExecute)), animated: true)
            navigationItem.rightBarButtonItem?.isEnabled = false
            collectionView.reloadData()
        }else{
            editBarButton.title = "编辑"
            collectionView.reloadData()
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonExecute)), animated: true)
        }
    }
    
    @objc private func rightBarButtonExecute() {
        if isMultiple {
            let alertVC = UIAlertController(title: "确定删除？", message: "您确定删除所选中的所有智能场景吗？", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "确定", style: .default) { (UIAlertAciton) in
//                var devicesNo: String = String()
//                for device: MyDevice in self.selectedDevice {
//                    devicesNo = devicesNo + "-\(device.deviceNo!)"
//                }
//                Network().request(target: MyService.delDevice(deviceNo:devicesNo), success: { (data) in
//                    self.viewModel.loadData()
//                })
            }
            actionOK.setValue(UIColor.theme, forKey: "titleTextColor")
            let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            actionCancel.setValue(UIColor.theme, forKey: "titleTextColor")
            alertVC.addAction(actionCancel)
            alertVC.addAction(actionOK)
            present(alertVC, animated: true, completion: nil)
        }else{
            let addSceneVC = R.storyboard.scene.addSceneNavigationController()
            //navigationController?.pushViewController(addSceneVC!, animated: true)
            present(addSceneVC!, animated: true, completion: nil)
        }
    }
    

    private func initCollectionView() {
        collectionView.mj_header = header
        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.register(R.nib.sceneCollectionViewCell(), forCellWithReuseIdentifier: sceneCellIdentifier)
        collectionView.allowsMultipleSelection = true
        collectionView.emptyDataSetDelegate = viewModel
        collectionView.emptyDataSetSource = viewModel
    }
    
    private func initViewModel() {
        viewModel.loadSceneData()
        viewModel.reloadTableViewClosure = { [weak self] () in
            self?.collectionView.reloadData()
        }
        viewModel.updateLoadingStatus = { [weak self] () in
            self?.header.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
}

extension SceneViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.scenes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sceneCellIdentifier, for: indexPath) as! SceneCollectionViewCell
        cell.scene = viewModel.scenes[indexPath.row]
        cell.isEditing = isMultiple
        cell.isSeleected = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMultiple {
            let cell = collectionView.cellForItem(at: indexPath) as! SceneCollectionViewCell
            cell.isSeleected = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SceneCollectionViewCell
        cell.isSeleected = false
    }
}
