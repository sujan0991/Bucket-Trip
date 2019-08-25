//
//  TripAndLocationsVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TripAndLocationsVC: UIViewController {
    
    @IBOutlet var scTableView:UITableView!
    
    var trips:[TripModel] = []
    
    var isLoadingData:Bool = false{
        didSet{
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trip Invitaion"
        scTableView.tableFooterView = UIView(frame: .zero)
        
        self.scTableView.register(UINib(nibName: "TripLocationCell", bundle: Bundle.main), forCellReuseIdentifier: "TripLocationCell")
        
        scTableView.delegate = self
        scTableView.dataSource = self
        scTableView.emptyDataSetSource = self
        scTableView.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoadingData = true

        APIManager.manager.getTripList { (trps) in
            self.trips = trps
            self.isLoadingData = false
            self.scTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func createTripAction(_ sender:UIButton){
        self.performSegue(withIdentifier: "CreateTripVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateTripVC"{
            let dest:UpdateTripVC = segue.destination as! UpdateTripVC
            let indx:IndexPath = sender as! IndexPath
            dest.trip = trips[indx.row]
        }
    }
}

extension TripAndLocationsVC:UITableViewDelegate,UITableViewDataSource{
    
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
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"TripLocationCell") as! TripLocationCell
        cell.selectionStyle = .none;
         let match = trips[indexPath.row]
         cell.fillTrip(match)
        cell.handler = {
            // Remove Trip
            guard let ti = match.trip_id else {return}
            let alertManager = UIAlertController.init(title: "", message: "Are you sure want to delete?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "NO", style: .default, handler: { (aciton) in
            })
            let noAction = UIAlertAction(title: "YES", style: .default, handler: { (aciton) in
                APIManager.manager.removeTrip(tripId: ti, withCompletionHandler: { (status, msg) in
                    
                    self.showStatus(status, msg: msg)
                    if status{
                        self.trips.remove(at: indexPath.row)
                        self.scTableView.reloadData()
                    }
                })
            })
            
            alertManager.addAction(okAction)
            alertManager.addAction(noAction)
            self.present(alertManager, animated: true, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        self.performSegue(withIdentifier: "UpdateTripVC", sender: indexPath)
    }
}

extension TripAndLocationsVC:DZNEmptyDataSetSource{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: isLoadingData ? "":"No Trip.")
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

extension TripAndLocationsVC:DZNEmptyDataSetDelegate{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}


