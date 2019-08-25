//
//  PassportDetailsVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 30/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class PassportDetailsVC: UIViewController {
    
    @IBOutlet var senderImageView:CircularImageView!
    @IBOutlet var taskImageView:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var countyLabel:UILabel!

    @IBOutlet var detailsLabel:UILabel!

    var selectedTrip:TripModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let trip = selectedTrip, let tid = trip.trip_id, let fid = trip.friend_id else {
            return
        }
        APIManager.manager.getPassportDetails(tripId: tid, friendId: fid) { (trp) in
            if trp.count > 0{
                self.filled(trp[0])
            }
        }
    }
    
    func filled(_ trip:TripModel)  {
        nameLabel?.text = trip.friend_name ?? ""
        countyLabel?.text = trip.friend_country ?? ""
        if trip.tasks.count > 0 {
            detailsLabel?.text = trip.tasks[0].task_description ?? ""
            if trip.tasks[0].feedBack.count > 0 {
                let feedback = trip.tasks[0].feedBack[0]
                let taskUrl = "\(API_K.BaseUrlStr)public/images/feedbackimage/\(feedback.image ?? "")"

                self.taskImageView?.kf.setImage(with: taskUrl.asImageResource(),placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }

       
        let urlSt = "\(API_K.BaseUrlStr)public/images/users/\(trip.avatar ?? "")"
        self.senderImageView?.kf.setImage(with: urlSt.asImageResource(),placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)
      

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func completeAction(_ sender:UIButton){
        guard let trip = selectedTrip, let tid = trip.trip_id, let fid = trip.friend_id else {
            return
        }
        
        APIManager.manager.confirmPassport(tripId: tid, friendId: fid) { (status, msg) in
            self.showStatus(status, msg: msg ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
}
