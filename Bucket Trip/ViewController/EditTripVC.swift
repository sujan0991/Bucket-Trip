//
//  EditTripVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class EditTripVC: UIViewController {
    
    @IBOutlet var scTableView:UITableView!
    @IBOutlet var fromDataLabel:UILabel!
    @IBOutlet var toDateLabel:UILabel!
    @IBOutlet var locationLabel:UILabel!
    @IBOutlet var friendNamesLabel:UILabel!

    var trip:TripModel?
    var friends:[UserModel] = []
    var selectedFriends:[UserModel] = []

    var selectedLocationId:String?
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

        scTableView.tableFooterView = UIView(frame: .zero)
        
        self.scTableView.register(UINib(nibName: "SuggestFriendCell", bundle: Bundle.main), forCellReuseIdentifier: "SuggestFriendCell")
        scTableView.delegate = self
        scTableView.dataSource = self
        guard let tripId = trp.trip_id else { return  }
        
        APIManager.manager.getTripDetails(tripId: tripId) { (trps) in
            if trps.count != 0 {
                let tps:TripModel = trps[0]
            self.selectedFriends = tps.invitedFriends
                let names = self.selectedFriends.flatMap { $0.user_name}
                let namesStr = names.joined(separator: ",")
                self.friendNamesLabel.text = namesStr.isEmpty ? "Invite a Friend":namesStr

            }
            APIManager.manager.getFriends { (users) in
                self.friends = users
                
                self.scTableView.reloadData()
            }
        }
    }
    

    func fill(_ trp:TripModel)  {
        self.fromDate = trp.start_date?.toDate(format: "yyyy-MM-dd").toDateString(format: "dd/MM/yyyy")
        self.toDate = trp.end_date?.toDate(format: "yyyy-MM-dd").toDateString(format: "dd/MM/yyyy")
        fromDataLabel.text = self.fromDate
        toDateLabel.text = self.toDate
        self.selectedLocationId = trp.location_id
        locationLabel.text = trp.location_name ?? ""
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createTrip(_ sender:UIButton){
        /*
        guard let trp = trip, let tripId = trp.trip_id else { return }

        let vMsg = ValidationManager.manager.validateCreateTripForm(selFriend:selectedFriends,location:selectedLocationId,fromDate:fromDate,toDate:toDate)
        if !vMsg.isEmpty{
            showConfimationAlert(vMsg)
          return
        }
 APIManager.manager.editTrip(tripId:tripId,selFriend:selectedFriends,location:selectedLocationId,fromDate:fromDate,toDate:toDate) { (status, msg) in
            self.showStatus(status, msg: msg)
        }*/
    }
    @IBAction func selectFromDateAction(_ sender:UIButton){
        dateSelectionType = .from
        addDatePicker()
    }
    
    @IBAction func selectToDateAction(_ sender:UIButton){
        dateSelectionType = .to
        addDatePicker()
    }
    
    @IBAction func selectLocationAction(_ sender:UIButton){
        self.performSegue(withIdentifier: "SelectionVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest:SelectionVC = segue.destination as! SelectionVC
        dest.selectionHandler = { (selLoc) in
            self.selectedLocationId = selLoc.location_id
            self.locationLabel.text = selLoc.location_name ?? ""
        }
    }
}

extension EditTripVC:UITableViewDelegate,UITableViewDataSource{
    
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


extension EditTripVC:TimePickerViewDelegate {
    
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
        default:
            print("")
        }
        picker.removeFromSuperview()
    }
}
