//
//  PNLoginViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/23.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit

class PNLoginViewController: UIViewController {
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHideNavigationBar()
    }
    
    @IBAction func selectCountry(_ sender: Any) {
        let selectCountryVC = SelectCountryTableViewController()
        selectCountryVC.backClosure = { value in
            let array = value.components(separatedBy: " ")
            self.countryBtn.setTitle(array.first, for: .normal)
            self.countryCodeLabel.text = array.last
        }
        let nav = UINavigationController.init(rootViewController: selectCountryVC)
        nav.navigationBar.tintColor = UIColor.black
        present(nav, animated: true)
    }
    
    
    @IBAction func login(_ sender: Any) {
    }
    
    @IBAction func skipToAnLogin(_ sender: Any) {
//        kRootVC = UIStoryboard.an_login_nav
    }
    
    
    private func configureHideNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
