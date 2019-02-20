//
//  DevicePowerBriefViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/20.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class DevicePowerBriefViewController: UIViewController, NavigationBarSetProtocol {

    @IBOutlet weak var todayPower: UILabel!
    
    @IBOutlet weak var currentV: UILabel!
    @IBOutlet weak var currentmA: UILabel!
    @IBOutlet weak var currentW: UILabel!
    @IBOutlet weak var totalPower: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var device: MyDevice!
    var currentPower: CurrentPower! {
        didSet {
            todayPower.text = String(currentPower.electricity)
            totalPower.text = String(currentPower.electricity)
            currentV.text = String(currentPower.voltage)
            currentmA.text = String(currentPower.current)
            currentW.text = String(currentPower.consume)
        }
    }
    var historyPowers: [HistoryPower]! = [HistoryPower]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavibar()
        tableView.separatorColor = UIColor.groupTableViewBackground
        Network().request(target: MyService.currentPower(deviceNo: device.deviceNo!), success:  { [weak self](data) in
            self?.currentPower = CurrentPower.deserialize(from: data as? [String: Any])
        })
        Network().request(target: MyService.historyPower(deviceNo: device.deviceNo!, date: "201809"), success:  { [weak self](data) in
            self?.historyPowers = [HistoryPower].deserialize(from: data as? [Any]) as? [HistoryPower]
        })
    }
}

extension DevicePowerBriefViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyPowers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let historyPower = historyPowers[indexPath.row]
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = "\(String((historyPower.date?.suffix(2))!))月"
        cell!.detailTextLabel?.text = String(historyPower.total)
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "2018"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let powerDetailVC = R.storyboard.device.devicePowerDetailViewController()
        powerDetailVC!.historyPower = historyPowers[indexPath.row]
        navigationController?.pushViewController(powerDetailVC!, animated: true)
    }
}
