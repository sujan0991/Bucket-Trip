//
//  CreateTripVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import SVProgressHUD

enum DateSelectionType {
    case from
    case to
}
class CreateTripVC: UIViewController {
    
    @IBOutlet var fromDataLabel:UILabel!
    @IBOutlet var toDateLabel:UILabel!
    @IBOutlet var tripTitleTextField:InputTextField!
    @IBOutlet var tripDriptionTextField:RoundTextView!
    @IBOutlet var friendNamesLabel:UILabel!
    @IBOutlet weak var locationNameLabel:UILabel!
    
    var fromPlace:SearchPlaceModel?
    var fromPlaceDetails:SearchPlaceDetailModel?

    var selectedFriends:[UserModel] = []

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
       // configureFromSearchTextField()
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

        let vMsg = ValidationManager.manager.validateCreateTripForm(title:tripTitleTextField.text!,selFriend:selectedFriends,location:fromPlace,locationDeatils:fromPlaceDetails,fromDate:fromDate,toDate:toDate)
        if !vMsg.isEmpty{
            showConfimationAlert(vMsg)
          return
        }
        APIManager.manager.createTrip(tripTitle:tripTitleTextField.text!,tripDescription: tripDriptionTextField.text!,selFriend:selectedFriends,location:fromPlace,locationDetails: fromPlaceDetails,fromDate:fromDate,toDate:toDate) { (status, msg) in
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
            dest.selectionHandler = { (selLoc) in
                self.selectedFriends = selLoc
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


extension CreateTripVC:TimePickerViewDelegate {
    
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
/*
extension CreateTripVC{
    
    // 2 - Configure a custom search text view
    fileprivate func configureFromSearchTextField() {
        // Set theme - Default: light
        fromTextField.theme = SearchTextFieldTheme.lightTheme()
        
        // Modify current theme properties
        fromTextField.theme.font = UIFont.systemFont(ofSize: 12)
        fromTextField.theme.bgColor = UIColor.lightGray.withAlphaComponent(0.2)
        fromTextField.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        fromTextField.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
        fromTextField.theme.cellHeight = 50
        fromTextField.theme.placeholderColor = UIColor.lightGray
        
        // Max number of results - Default: No limit
        fromTextField.maxNumberOfResults = 5
        
        // Max results list height - Default: No limit
        fromTextField.maxResultsListHeight = 200
        
        // Set specific comparision options - Default: .caseInsensitive
        fromTextField.comparisonOptions = [.caseInsensitive]
        
        // You can force the results list to support RTL languages - Default: false
        fromTextField.forceRightToLeft = false
        
        // Customize highlight attributes - Default: Bold
        fromTextField.highlightAttributes = [NSAttributedStringKey.backgroundColor.rawValue: UIColor.yellow, NSAttributedStringKey.font.rawValue:UIFont.boldSystemFont(ofSize: 12)]
        
        // Handle item selection - Default behaviour: item title set to the text field
        fromTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            guard let str  = item.strFormat else { return  }
            self.fromPlace = item
           
            GMSAPIManager.manager.getPlacePhoto(place: item, withCompletionHandler: { (status, spd, msg) in
                
            })
            GMSAPIManager.manager.getPlaceDetail(place: item, withCompletionHandler: { (status, spd, msg) in
                if status{
                    self.fromPlaceDetails = spd
                    
                }
            })
            self.fromTextField.text = str.displayName()
        }
        
        // Update data source when the user stops typing
        fromTextField.userStoppedTypingHandler = {
            if let criteria = self.fromTextField.text {
                if criteria.characters.count > 1 {
                    
                    // Show loading indicator
                    self.fromTextField.showLoadingIndicator()
                    
                    self.filterAcronymInBackground(criteria) { results in
                        // Set new items to filter
                        self.fromTextField.filterItems(results)
                        
                        // Stop loading indicator
                        self.fromTextField.stopLoadingIndicator()
                    }
                }
            }
        }
    }
    
    // Hide keyboard when touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    ////////////////////////////////////////////////////////
    // Data Sources
    
    fileprivate func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [SearchPlaceModel]) -> Void)) {
        
        GMSAPIManager.manager.getPlaces(searchString: criteria) { (status, searchPlaces, msg) in
            if searchPlaces.count > 0 {
                DispatchQueue.main.async {
                    callback(searchPlaces)
                }
            }
            else{
                callback([])
            }
        }
    }
}
*/
