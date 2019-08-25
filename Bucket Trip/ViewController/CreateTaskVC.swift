//
//  CreateTaskVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 29/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

enum Status {
    case  showAll
    case  onlyMe
}

class CreateTaskVC: UIViewController {
    @IBOutlet var tripTitleLabel:UILabel!
    @IBOutlet var tripDescriptionLabel:UILabel!
    @IBOutlet var tripImageView:UIImageView!
   // @IBOutlet var scTableView:UITableView!
    @IBOutlet var inputTextView:RoundTextView!
   // @IBOutlet var mapView:MKMapView!
    @IBOutlet var segmentControl:UISegmentedControl!

    var selectedTrip:TripModel?
    
    var status:Status = .onlyMe{
        didSet{
            segmentControl.selectedSegmentIndex = status == .showAll ? 0:1
        }
    }

   // var tasks:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        status = .onlyMe
        
       // scTableView.tableFooterView = UIView(frame: .zero)
        if let st = selectedTrip {
            fill(st)
        }
       // self.scTableView.register(UINib(nibName: "TaskTableCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableCell")
       // scTableView.delegate = self
       // scTableView.dataSource = self
       // self.scTableView.reloadData()
    }

    func fill(_ trip:TripModel) {
        tripTitleLabel.text = trip.trip_title
        tripDescriptionLabel.text = trip.trip_description
        let urlStr = trip.location_image ?? "" //"\(API_K.BaseUrlStr)public/images/locations/\(trip.image ?? "")"
        
        self.tripImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func doneAction(_ sender:UIButton){
        guard let st = selectedTrip, let tripId = st.ID else
        {
            return
            
        }
        guard let input = inputTextView.text, !input.isEmpty else {
            showConfimationAlert("Please add any task.")
            return
        }
      
        APIManager.manager.createTask(tripId: tripId, tasks:[input],visibility:self.status) { (status, msg) in
            self.showStatus(status, msg: msg ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addAction(_ sender:UIButton){
        guard let input = inputTextView.text, !input.isEmpty else {
            showConfimationAlert("Please add any task.")
            return
        }
        //tasks.append(input)
        inputTextView.text = ""
       // scTableView.reloadData()
    }
    
    @IBAction func segmentChanged(_ sender:UISegmentedControl){
        status = sender.selectedSegmentIndex == 0 ? .showAll:.onlyMe
    }
}

/*
extension CreateTaskVC:UITableViewDelegate,UITableViewDataSource{
    
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
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"TaskTableCell") as! TaskTableCell
        cell.selectionStyle = .none;
         let match = tasks[indexPath.row]
        cell.fillInfo(menu: match)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tasks.remove(at: indexPath.row)
            scTableView.reloadData()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "Remove"
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
*/
