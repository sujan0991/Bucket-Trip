//
//  PendingTaskDetailsVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class PendingTaskDetailsVC: UIViewController {
    
    @IBOutlet var senderImageView:CircularImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var countyLabel:UILabel!
    @IBOutlet var taskDetailLabel:UILabel!

    var selectedTrip:TripModel?

    var tasks:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let st = selectedTrip, let tid = st.trip_id else {
            return
        }
        self.fillSenderInfo(st)

        APIManager.manager.getTripDetails(tripId: tid) { (trips) in
            print(trips)
            if trips.count > 0{
                self.fill(trips[0])
            }
        }
    }

    func fill(_ trip:TripModel)  {
        self.taskDetailLabel?.text = trip.tripDetails ?? ""
    }
    func fillSenderInfo(_ trip:TripModel)  {
        nameLabel.text = trip.friend_name ?? ""
        countyLabel.text = trip.friend_country ?? ""
        let urlStr = "\(API_K.BaseUrlStr)public/images/users/\(trip.avatar ?? "")"
        self.senderImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptAction(_ sender:UIButton){
        guard let st = self.selectedTrip, let tpid = st.trip_id, let fid = st.friend_id else {
            return
        }
        APIManager.manager.acceptRejectTask(tripId: tpid,friendId:fid , type: .accept) { (status, msg) in
            self.showStatus(status, msg: msg ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func declineAction(_ sender:UIButton){
        guard let st = self.selectedTrip, let tpid = st.trip_id,let fid = st.friend_id else {
            return
        }
        APIManager.manager.acceptRejectTask(tripId: tpid,friendId:fid , type: .reject) { (status, msg) in
            self.showStatus(status, msg: msg ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
}


