//
//  DeviceTypeSelectViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/21.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class DeviceTypeSelectViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let titles = ["插座", "开关", "照明", "其他设备"]
    let images = [R.image.ic_socket(), R.image.ic_turnon(), R.image.ic_light(), R.image.ic_others()]
    
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (kScreenWidth-2*collectionMargin)/3, height: (kScreenWidth-2*collectionMargin)/3)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, collectionMargin, 0, collectionMargin)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.register(R.nib.deviceCollectionViewCell(), forCellWithReuseIdentifier: identifier)
    }
}

extension DeviceTypeSelectViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DeviceCollectionViewCell
        cell.deviceNameLabel.textColor = UIColor.black
        cell.deviceNameLabel.text = titles[indexPath.row]
        cell.icon.image = images[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deviceConfigFirstVC = R.storyboard.deviceConfig.deviceConfigFirstViewController()
        navigationController?.pushViewController(deviceConfigFirstVC!, animated: true)
    }
}
