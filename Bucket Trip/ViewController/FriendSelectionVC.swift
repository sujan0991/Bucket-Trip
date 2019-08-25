//
//  FriendSelectionVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 1/8/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class FriendSelectionVC: UIViewController {
    
    @IBOutlet var scTableView:UITableView!
    var friends:[UserModel] = []
    var selectedFriends:[UserModel] = []
    @IBOutlet var friendNamesLabel:UILabel!

    var selectionHandler: (([UserModel]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scTableView.tableFooterView = UIView(frame: .zero)
        self.scTableView.register(UINib(nibName: "SuggestFriendCell", bundle: Bundle.main), forCellReuseIdentifier: "SuggestFriendCell")
        scTableView.delegate = self
        scTableView.dataSource = self

        self.scTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.manager.getFriends { (users) in
            self.friends = users
            self.scTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneAction(_ sender:UIButton){
      /*  guard let selLoc = self.selectedLocation else {
            self.navigationController?.popViewController(animated: true)
            return
        }*/
        if let handler = self.selectionHandler {
            handler(selectedFriends)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension FriendSelectionVC:UITableViewDelegate,UITableViewDataSource{
    
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
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"SuggestFriendCell") as! SuggestFriendCell
        cell.selectionStyle = .none;
        let match = friends[indexPath.row]
        cell.setFriendInfo(match)
        
        let sortFrnds = self.selectedFriends.filter({ $0.user_id ==  match.user_id})
        cell.addButtonType = sortFrnds.count == 0 ? .tripinvite:.tripinvited
        
        cell.addHandler = {
            let sortFrnd = self.selectedFriends.filter({ $0.user_id ==  match.user_id})
            if sortFrnd.count == 0 {
                self.selectedFriends.append(match)
            }
            else{
                self.selectedFriends.remove(at: indexPath.row)
            }
            let names = self.selectedFriends.flatMap { $0.user_name}
            let namesStr = names.joined(separator: ",")
            self.friendNamesLabel.text = namesStr.isEmpty ? "Invite a Friend":namesStr
            self.scTableView.reloadData()
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


