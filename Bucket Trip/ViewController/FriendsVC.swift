//
//  FriendsVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 2/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD

class FriendsVC: UIViewController {
    
    @IBOutlet var scTableView:UITableView!
    var isLoadingData:Bool = false{
        didSet{
        }
    }
    var suggestedFriends:[UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FRIENDS"
        scTableView.tableFooterView = UIView(frame: .zero)
        
        self.scTableView.register(UINib(nibName: "SuggestFriendCell", bundle: Bundle.main), forCellReuseIdentifier: "SuggestFriendCell")
        scTableView.delegate = self
        scTableView.dataSource = self
        self.scTableView.emptyDataSetSource = self
        self.scTableView.emptyDataSetDelegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        suggestedFriends = []
        isLoadingData = true
        loadData()
    }
    
    func loadData()  {
        APIManager.manager.getFriends { (users) in
            self.suggestedFriends = users
            
            print("self.suggestedFriends :",self.suggestedFriends)
            
            self.isLoadingData = false
            self.scTableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func add(_ sender:UIButton){
        self.performSegue(withIdentifier: "AddFriendsVC", sender: self)
    }
}

extension FriendsVC:UITableViewDelegate,UITableViewDataSource{
    
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
        cell.addButtonType = .friend
         let match = suggestedFriends[indexPath.row]
         cell.setFriendInfo(match)
        cell.addHandler = {
            guard let userId = match.user_id else { return  }
            APIManager.manager.performFriendRequestAction(userId: "\(userId)",type: .remove, withCompletionHandler: { (status, msg) in
                if status{
                    SVProgressHUD.showSuccess(withStatus: msg ?? "")
                    self.loadData()
                }
                else {
                    SVProgressHUD.showError(withStatus: msg ?? "")
                }
            })
        }
        cell.profileTapHandler = {
            AppSessionManager.shared.navigateOtherProfile(match,from: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}

extension FriendsVC:DZNEmptyDataSetSource{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: isLoadingData ? "":"No friends.")
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

extension FriendsVC:DZNEmptyDataSetDelegate{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
