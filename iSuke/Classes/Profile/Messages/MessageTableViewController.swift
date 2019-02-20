//
//  MessageTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/4.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class MessageTableViewController: UITableViewController {
    
    let header = { () -> UIRefreshControl in
        let header = UIRefreshControl()
        header.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return header
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = header
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func loadData() {
        let provider = MoyaProvider<MyService>(plugins: [MyNetworkLoggerPlugin(), RequestLoadingPlugin()])
        provider.request(.msgList(pageNum: 1)) { (result) in
            switch result{
            case let .success(response):
                let rootModel = RooteModel.init(jsonData: JSON.init(response.data))
                if rootModel.code == RT_SUCCESS{
                    
                }
            case .failure(_): break
                
            }
        }
        
    }
}


// MARK: - Table view data source
extension MessageTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageTableViewCell.self), for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
}
