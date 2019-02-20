//
//  PersonalInfoTableViewController.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/5.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import UIKit
import Moya
import Kingfisher
import SwiftyJSON

class PersonalInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var phone: UILabel!
    

    lazy var imagePickerVC = { () -> UIImagePickerController in
        let vc = UIImagePickerController()
        vc.delegate = self;
        vc.allowsEditing = true;
        vc.sourceType = .savedPhotosAlbum;
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    private func updateUI() {
        icon.kf.setImage(with: URL(string: (UserManager.share.loginUser?.avatar)!))
        phone.text = UserManager.share.loginUser?.phone
        nickName.text = UserManager.share.loginUser?.loginName?.count == 0 ? R.string.localizable.un_SET_NIKENAME() : (UserManager.share.loginUser?.loginName)!
    }

}

extension PersonalInfoTableViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let alertAlbum = UIAlertAction(title: R.string.localizable.photo_ALBUM(), style: .default) { (action) in
                self.imagePickerVC.sourceType = .savedPhotosAlbum
                self.present(self.imagePickerVC, animated: true, completion: nil)
            }
            let alertPhoto = UIAlertAction(title: R.string.localizable.take_PICTURE(), style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePickerVC.sourceType = .camera
                    self.present(self.imagePickerVC, animated: true, completion: nil)
                }
            }
            alertVC.addAction(alertPhoto)
            alertVC.addAction(alertAlbum)
            alertVC.addAction(UIAlertAction(title: R.string.localizable.canceL(), style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
        default: break
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let icon  = info[UIImagePickerControllerEditedImage]
        let imageData = UIImageJPEGRepresentation(icon as! UIImage, 0.9)
        
        Network().request(target: MyService.changeAvatar(image: imageData!), success:{ [weak self] (data) in
            UserManager.share.loginUser?.avatar = (data as! [String: Any])["avatar"] as? String
            UserManager.saveLoginUser(loginUser: UserManager.share.loginUser!)
            self?.updateUI()
        })
        self.dismiss(animated: true, completion: nil)
    }
}
