//
//  OtherProfileVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 30/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD


class OtherProfileVC: UIViewController {

    @IBOutlet var timelineImageView:UIImageView!
    @IBOutlet var profileImageView:CircularImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var countyLabel:UILabel!
    @IBOutlet var aboutMeLabel:UILabel!
    @IBOutlet var emailLabel:UILabel!
    @IBOutlet var phoneLabel:UILabel!

    
    var user:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let cu = user else { return }
        self.fill(cu)
/*
      guard let cu = user, let userId = cu.user_id else { return }
        APIManager.manager.getOtherProfile("\(userId)") { (status, um, msg) in
            if status{
                if let u = um{
                    self.user = u
                    self.fill(u)
                }
            }
            else{
                self.showStatus(status, msg: msg)
            }
        }
*/
    }

    func fill(_ um:UserModel)  {
        aboutMeLabel.text = um.about_me ?? ""
        nameLabel.text = um.full_name ?? ""
        countyLabel.text = um.country ?? ""
        emailLabel.text = um.email ?? ""
        phoneLabel.text = um.phone ?? ""
        let urlStr = "\(API_K.BaseUrlStr)public/images/users/\(um.avatar ?? "")"
        self.profileImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)

        let urlTStr = "\(API_K.BaseUrlStr)public/images/users/\(um.cover_photo ?? "")"
        self.timelineImageView?.kf.setImage(with: urlTStr.asImageResource(),placeholder: UIImage.init(named: "td"), options: nil, progressBlock: nil, completionHandler: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    
    @IBAction func travelHistoryAction(_ sender:UIButton){
       // self.performSegue(withIdentifier: "MyTravelHistoryVC", sender: self)
    }
    
    @IBAction func blogPostAction(_ sender:UIButton){
        //self.performSegue(withIdentifier: "BlogPostVC", sender: self)
    }
}


