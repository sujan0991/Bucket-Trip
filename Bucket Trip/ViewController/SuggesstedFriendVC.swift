//
//  SuggesstedFriendVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 25/5/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SVProgressHUD


class SuggesstedFriendVC: UIViewController {
    
    @IBOutlet var scTableView:UITableView!
    
    var suggestedFriends:[UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.title = "SCHEDULE"
        scTableView.tableFooterView = UIView(frame: .zero)
        
        self.scTableView.register(UINib(nibName: "SuggestFriendCell", bundle: Bundle.main), forCellReuseIdentifier: "SuggestFriendCell")
        scTableView.delegate = self
        scTableView.dataSource = self
        self.scTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        suggestedFriends = []
        APIManager.manager.getSuggestedFriends { (users) in
            self.suggestedFriends =  users
            self.scTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipAction(_ sender:UIButton){
        AppSessionManager.shared.navigateToHome()
    }
}

extension SuggesstedFriendVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"SuggestFriendCell") as! SuggestFriendCell
        cell.selectionStyle = .none;
        let suggestedFnd:UserModel = suggestedFriends[indexPath.row]
        cell.setFriendInfo(suggestedFnd)
        
        cell.addHandler = {
            guard let userId = suggestedFnd.user_id else { return  }
            APIManager.manager.inviteFriend(userId: "\(userId)", withCompletionHandler: { (status,msg) in
                if status{
                    SVProgressHUD.showSuccess(withStatus: msg)
                }
                else{
                    SVProgressHUD.showError(withStatus: msg)
                }
            })
        }
        
        cell.profileTapHandler = {
            AppSessionManager.shared.navigateOtherProfile(suggestedFnd,from: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}
