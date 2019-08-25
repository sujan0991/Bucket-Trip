//
//  UpdateTripVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import SVProgressHUD

class UpdateTripVC: UIViewController {
    
    @IBOutlet var fromDataLabel:UILabel!
    @IBOutlet var toDateLabel:UILabel!
    @IBOutlet var tripTitleTextField:InputTextField!
    @IBOutlet var tripDriptionTextField:RoundTextView!
    @IBOutlet var friendNamesLabel:UILabel!
    @IBOutlet weak var locationNameLabel:UILabel!
    
    var fromPlace:SearchPlaceModel?
    var fromPlaceDetails:SearchPlaceDetailModel?

    var selectedFriends:[UserModel] = []

    var trip:TripModel?
    var fromDate:String?
    var toDate:String?
    var dateSelectionType:DateSelectionType = .from{
        didSet{}
    }
    
    lazy var picker : TimePickerView = {
        let pic = TimePickerView.instance(withNibName: "TimePickerView", bundle: Bundle.main, owner: self) as! TimePickerView
        return pic
    }()
    
    func addDatePicker()  {
        self.view.endEditing(true)
        self.view.addSubview(picker)
        picker.delegate = self
        picker.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(250)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let trp = trip else { return }
        fill(trp)
        guard let tripId = trp.trip_id else { return  }
        
        APIManager.manager.getTripDetails(tripId: tripId) { (trps) in
            if trps.count != 0 {
                let tps:TripModel = trps[0]
                self.selectedFriends = tps.invitedFriends
                let names = self.selectedFriends.flatMap { $0.user_name}
                let namesStr = names.joined(separator: ",")
                self.friendNamesLabel.text = namesStr.isEmpty ? "Invite a Friend":namesStr
                
            }
        }
    }
    
    
    
    func fill(_ trp:TripModel)  {
        self.fromDate = trp.start_date?.toDate(format: "yyyy-MM-dd").toDateString(format: "dd/MM/yyyy")
        self.toDate = trp.end_date?.toDate(format: "yyyy-MM-dd").toDateString(format: "dd/MM/yyyy")
        fromDataLabel.text = self.fromDate
        toDateLabel.text = self.toDate
        self.tripDriptionTextField.text = trp.tripDetails ?? ""
        self.tripTitleTextField.text = trp.trip_title ?? ""
       // self.selectedLocationId = trp.location_id
       // locationLabel.text = trp.location_name ?? ""
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createTrip(_ sender:UIButton){
        guard let trp = trip else { return }
        guard let tripId = trp.trip_id else { return  }

        let vMsg = ValidationManager.manager.validateUpdateTripForm(title:tripTitleTextField.text!,selFriend:selectedFriends,location:fromPlace,locationDeatils:fromPlaceDetails,fromDate:fromDate,toDate:toDate)
        if !vMsg.isEmpty{
            showConfimationAlert(vMsg)
          return
        }
        APIManager.manager.updateTrip(tripId:tripId ,tripTitle:tripTitleTextField.text!,tripDescription: tripDriptionTextField.text!,selFriend:selectedFriends,location:fromPlace,locationDetails: fromPlaceDetails,fromDate:fromDate,toDate:toDate,locationImage: "https://placeimg.com/640/480/nature") { (status, msg) in
            self.showStatus(status, msg: msg)
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func selectFromDateAction(_ sender:UIButton){
        dateSelectionType = .from
        addDatePicker()
    }
    
    @IBAction func selectToDateAction(_ sender:UIButton){
        dateSelectionType = .to
        addDatePicker()
    }
    
    @IBAction func searchLocationAction(_ sender:UIButton){
        self.performSegue(withIdentifier: "LocationSearchVC", sender: self)
    }
    
    @IBAction func inviteFriendAction(_ sender:UIButton){
        self.performSegue(withIdentifier: "FriendSelectionVC", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendSelectionVC"{
            let dest:FriendSelectionVC = segue.destination as! FriendSelectionVC
            dest.selectedFriends = selectedFriends
            dest.selectionHandler = { (selFrnds) in
                self.selectedFriends = selFrnds
                let names = self.selectedFriends.flatMap { $0.user_name}
                let namesStr = names.joined(separator: ",")
                self.friendNamesLabel.text = namesStr.isEmpty ? "Invite a Friend":namesStr
            }
        }
        if segue.identifier == "LocationSearchVC"{
            let dest:LocationSearchVC = segue.destination as! LocationSearchVC
            
            dest.fromPlace = fromPlace
            dest.selectionHandler = { (selLoc) in
                self.fromPlace = selLoc
                if let sf = selLoc.strFormat{
                    self.locationNameLabel?.text = sf.displayName()
                }
                else{
                    self.locationNameLabel.text = "Search a location"
                }
                GMSAPIManager.manager.getPlaceDetail(place: selLoc, withCompletionHandler: { (status, spd, msg) in
                    if status{
                        self.fromPlaceDetails = spd
                        
                    }
                })
            }

        }
    }
}


extension UpdateTripVC:TimePickerViewDelegate {
    
    func didPressCancel() {
        picker.removeFromSuperview()
    }
    
    func didSelect(_ date:Date) {
        switch dateSelectionType {
        case .from:
            self.fromDate = date.formattedTime()
            fromDataLabel.text = self.fromDate
        case .to:
            self.toDate = date.formattedTime()

            toDateLabel.text = self.toDate
        }
        picker.removeFromSuperview()
    }
}

