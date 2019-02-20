//
//  SelectCountryTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/24.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

private let kCountryCellID = "kCountryCellID"

class SelectCountryTableViewController: UITableViewController {
    
    var backClosure:((_ value:String) -> Void)?
    private var countrys:[String]! = []
    fileprivate lazy var searchController:UISearchController! = {
        let searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchController.searchBar.tintColor = UIColor.black
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        configureNavBar()
        configureTableView()
    }
    
    private func initializeData(){
        let plistPathCH = Bundle.main.path(forResource: "sortedChnames", ofType: "plist")
        let countryDic = NSDictionary(contentsOfFile: plistPathCH!)
        for country in countryDic!.allValues {
            countrys = countrys + (country as! [String])
        }
    }
    
    private func configureNavBar(){
        title = "国家地区"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(self.cancelSelect))
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
        }else{
            tableView.tableHeaderView = searchController.searchBar
            definesPresentationContext = true
        }
    }
    
    private func configureTableView(){
        tableView.separatorColor = UIColor.clear        
        tableView.register(UINib(nibName: String(describing: SelectCountryTableViewCell.self), bundle: nil), forCellReuseIdentifier: kCountryCellID)
    }
    
    @objc private func cancelSelect(){
        dismiss(animated: true, completion: nil)
    }
}


extension SelectCountryTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SelectCountryTableViewCell = tableView.dequeueReusableCell(withIdentifier: kCountryCellID) as! SelectCountryTableViewCell
        let countryName = countrys[indexPath.row]
        let array = countryName.components(separatedBy: " ")
        
        cell.textLabel?.text = array.first
        cell.detailTextLabel?.text = array.last
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countrys.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let string = countrys[indexPath.row]
        backClosure!(string)
        dismiss(animated: true)
    }
}

