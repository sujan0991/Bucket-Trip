//
//  AddFriendsVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 2/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD

enum FriendAddType {
    case invite
    case accept
}

class AddFriendsVC: UIViewController {
    
    @IBOutlet var scTableView:UITableView!
    var isLoadingData:Bool = false{
        didSet{
        }
    }

    var suggestedFriends:[UserModel] = []
    
    @IBOutlet var inviteTitleButton:UIButton!
    @IBOutlet var acceptTitleButton:UIButton!
    
    var segType:FriendAddType = .invite{
        didSet{
            inviteTitleButton.setTitleColor(segType == .invite ? UIColor.white:UIColor.init(red: 90/255, green: 90/255, blue: 90/255, alpha: 1), for: .normal)
            acceptTitleButton.setTitleColor(segType == .accept ? UIColor.white:UIColor.init(red: 90/255, green: 90/255, blue: 90/255, alpha: 1), for: .normal)
            let selectedImage = UIImage.init(named: "add_button")
            let normalImage = UIImage.init(named: "added")
            
            inviteTitleButton.setBackgroundImage(segType == .invite ? selectedImage:normalImage, for: .normal)
            
            acceptTitleButton.setBackgroundImage(segType == .accept ? selectedImage:normalImage, for: .normal)
            
            if segType == .invite{
                APIManager.manager.getSuggestedFriends { (users) in
                    self.suggestedFriends = users
                    self.isLoadingData = false
                    self.scTableView.reloadData()

                }
            }
            else{
                APIManager.manager.getListWouldFriends { (users) in
                    self.suggestedFriends = users
                    self.isLoadingData = false
                    self.scTableView.reloadData()
                }
            }
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Friends"
        scTableView.tableFooterView = UIView(frame: .zero)
        
        self.scTableView.register(UINib(nibName: "SuggestFriendCell", bundle: Bundle.main), forCellReuseIdentifier: "SuggestFriendCell")
        scTableView.delegate = self
        scTableView.dataSource = self
        scTableView.emptyDataSetSource = self
        scTableView.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        suggestedFriends = []
        isLoadingData = true
        segType = .invite
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func inviteSelectAction(_ sender:UIButton){
        segType = .invite
    }
    @IBAction func acceptSelectAction(_ sender:UIButton){
        segType = .accept
    }
}

extension AddFriendsVC:UITableViewDelegate,UITableViewDataSource{
    
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
         let match = suggestedFriends[indexPath.row]
         cell.setFriendInfo(match)
        cell.addButtonType = segType == .invite ? .invite:.accept
        cell.profileTapHandler = {
            AppSessionManager.shared.navigateOtherProfile(match,from: self)
        }
        cell.addHandler = {
            guard let userId = match.user_id else { return  }
            if self.segType == .invite{
                APIManager.manager.inviteFriend(userId: "\(userId)", withCompletionHandler: { (status, msg) in
                    if status{
                        SVProgressHUD.showSuccess(withStatus: msg ?? "")
                        self.segType = .invite
                        /*
                        let indexOfProd = self.suggestedFriends.index{$0.user_id == match.user_id}
                        if let ind = indexOfProd {
                            self.suggestedFriends.remove(at: ind)
                            self.scTableView.reloadData()
                        }*/
                    }
                    else {
                        SVProgressHUD.showError(withStatus: msg ?? "")
                    }
                })
            }
            else{
                let alertVC = UIAlertController(title: "", message: "Do you want to accept request?", preferredStyle: .actionSheet)
                let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: { (aciton) in
                    APIManager.manager.performFriendRequestAction(userId: "\(userId)",type:.accept, withCompletionHandler: { (status, msg) in
                        if status{
                            SVProgressHUD.showSuccess(withStatus: msg ?? "")
                            self.segType = .accept
                          
                        }
                        else {
                            SVProgressHUD.showError(withStatus: msg ?? "")
                        }
                    })
                })
                let rejectAction = UIAlertAction(title: "Reject", style: .default, handler: { (aciton) in
                    APIManager.manager.performFriendRequestAction(userId: "\(userId)",type: .reject, withCompletionHandler: { (status, msg) in
                        if status{
                            SVProgressHUD.showSuccess(withStatus: msg ?? "")
                            self.segType = .accept
                        }
                        else {
                            SVProgressHUD.showError(withStatus: msg ?? "")
                        }
                    })
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (aciton) in
                    
                })
                alertVC.addAction(acceptAction)
                alertVC.addAction(rejectAction)
                alertVC.addAction(cancelAction)
                self.present(alertVC, animated: true, completion: nil)
            }
           
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}


extension AddFriendsVC:DZNEmptyDataSetSource{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: isLoadingData ? "":"No users.")
    }
    /*
     func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
     return  -100
     }
     */
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.init(red: 241, green: 241, blue: 241)
    }
}

extension AddFriendsVC:DZNEmptyDataSetDelegate{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
