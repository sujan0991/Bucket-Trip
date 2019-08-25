//
//  MenuVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 25/5/18.
//  Copyright © 2018 DL. All rights reserved.
//


import UIKit
import SwiftyJSON
import DrawerController
import Gloss
import SVProgressHUD


class MenuVC: UIViewController {
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var profileImageView: CircularImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var menus:[Menu] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTable.tableFooterView = UIView(frame: .zero)
        
        self.menuTable.register(UINib(nibName: "MenuTableCell", bundle: Bundle.main), forCellReuseIdentifier: "MenuTableCell")
        if let path = Bundle.main.path(forResource: "SideMenus", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let json = JSON(data)
                if let jsonDataArray = json.arrayObject as? [Gloss.JSON] {
                    
                    if let histories = [Menu].from(jsonArray: jsonDataArray) {
                        menus = histories
                        
                    } else {
                        menus = []
                    }
                    self.menuTable.reloadData()
                    
                    
                } else {
                    print("Could not make into JSON")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        self.menuTable.dataSource = self
        self.menuTable.delegate = self
       self.menuTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.manager.getMyProfile { (status, um, msg) in
            if status{
                if let u = um{
                    self.fill(u)
                }
            }
            else{
                self.showStatus(status, msg: msg)
            }
        }
        
    }
    
    func fill(_ um:UserModel)  {
        nameLabel.text = um.full_name ?? ""
        let urlStr = "\(API_K.BaseUrlStr)public/images/users/\(um.avatar ?? "")"
        self.profileImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension MenuVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"MenuTableCell") as! MenuTableCell
        cell.selectionStyle = .none;
        let menu = menus[indexPath.row]
        cell.fillMenuInfo(menu: menu)
        cell.isBottomCell = indexPath.row == menus.count - 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let homeNav:UINavigationController = self.evo_drawerController?.centerViewController as! UINavigationController
        let homeVC:HomeVC = homeNav.viewControllers[0] as! HomeVC
        
        let menu:Menu = menus[indexPath.row]
        switch menu.menu_id {
        case 1:// Home
            //AppSessionManager.shared.navigateToHome()
            print("Home")
        case 2://Pending Task
            print("Pending Task")
            homeVC.performSegue(withIdentifier: "PendingTasksVC", sender: homeVC)
        case 3://Accepted Task
            print("Accepted Task")
            
            homeVC.performSegue(withIdentifier: "AcceptedTasksVC", sender: homeVC)

        case 4://Friends
            print("Friends")
         homeVC.performSegue(withIdentifier: "FriendsVC", sender: homeVC)
            
        case 5://Trip and Location
            print("Trip and Location")
            
            homeVC.performSegue(withIdentifier: "TripAndLocationsVC", sender: homeVC)

        case 6://Trip Invitation
            homeVC.performSegue(withIdentifier: "TripInvitedVC", sender: homeVC)
        case 7://Passport and Travel
            print("Passport")
            homeVC.performSegue(withIdentifier: "PassportAndTravelVC", sender: homeVC)
        case 8://Profile
            print("6")
            homeVC.performSegue(withIdentifier: "ProfileVC", sender: homeVC)

        case 9://Blog
            homeVC.performSegue(withIdentifier: "BlogPostVC", sender: homeVC)

        case 10://Logout
            APIManager.manager.logOut(completion: { (status, msg) in
                if status{
                    SVProgressHUD.showSuccess(withStatus: msg)
                    AppSessionManager.shared.logOut()
                    
                }
                else{
                    SVProgressHUD.showError(withStatus: msg)
                }
            })
        default:
            print("Default")
        }
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }
}



