//
//  AddSceneTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/23.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit



//#define ITEM_WIDTH  (SCREEN_WIDTH - 4 * kMagin) / 3
let itemWidth = (kScreenWidth - 4*collectionMargin)/3


class AddSceneTableViewController: UITableViewController {
    
    @IBOutlet weak var sceneName: UITextField!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var deviceStatus: UILabel!

    @IBOutlet weak var conditionCollection: UICollectionView!
    @IBOutlet weak var deviceCollection: UICollectionView!
    
    var conditionCollectionFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth/4*3)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }
    
    var deviceCollectionFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth/2)
        flowLayout.sectionInset = UIEdgeInsetsMake(collectionMargin, collectionMargin, 0, collectionMargin)
        flowLayout.minimumLineSpacing = 15
        return flowLayout
    }
    
    var sceneConditions = [SceneCondition]() {
        didSet {
            conditionCollection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        Network().request(target: MyService.getSceneSelection(language: "zh_CN"), success: { (data) in
            self.sceneConditions = ([SceneCondition].deserialize(from: data as? [Any]) as? [SceneCondition])!
        }) { (error) in
            
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmExecute(_ sender: Any) {
        
    }
    
    private func initUI() {
        conditionCollection.collectionViewLayout = conditionCollectionFlowLayout
        deviceCollection.collectionViewLayout = deviceCollectionFlowLayout
        conditionCollection.register(R.nib.deviceCollectionViewCell(), forCellWithReuseIdentifier: "conditionCell")
    }
}

extension AddSceneTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sceneConditions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == conditionCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "conditionCell", for: indexPath) as! DeviceCollectionViewCell
            cell.sceneCondition = sceneConditions[indexPath.row]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.deviceSceneCell, for: indexPath)
        return cell!
    }
    
    
}
