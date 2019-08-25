//
//  TripInvitedVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TripInvitedVC: UIViewController {
    
    @IBOutlet var scTableView:UITableView!
    var invitedTrips:[TripModel] = []
    
    var isLoadingData:Bool = false{
        didSet{}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trip Invitaion"

        scTableView.tableFooterView = UIView(frame: .zero)
        isLoadingData = true

        self.scTableView.register(UINib(nibName: "TripInvitationCell", bundle: Bundle.main), forCellReuseIdentifier: "TripInvitationCell")
        scTableView.delegate = self
        scTableView.dataSource = self
    
        scTableView.emptyDataSetSource = self
        scTableView.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.manager.getInvitedTripList { (trps) in
            self.invitedTrips = trps
            self.isLoadingData = false
            self.scTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateTaskVC"{
            let dest:CreateTaskVC = segue.destination as! CreateTaskVC
            let indp:IndexPath = sender as! IndexPath
            dest.selectedTrip = self.invitedTrips[indp.row]
        }
    }
}

extension TripInvitedVC:UITableViewDelegate,UITableViewDataSource{
    
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
        return invitedTrips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"TripInvitationCell") as! TripInvitationCell
        cell.selectionStyle = .none;
         let match = invitedTrips[indexPath.row]
         cell.setInfo(match)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        self.performSegue(withIdentifier: "CreateTaskVC", sender: indexPath)
    }
}


extension TripInvitedVC:DZNEmptyDataSetSource{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: isLoadingData ? "":"No trip invataion.")
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

extension TripInvitedVC:DZNEmptyDataSetDelegate{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

