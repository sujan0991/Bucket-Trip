//
//  LocationSearchVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 13/8/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SVProgressHUD
import ViewUtils
import SnapKit


class LocationSearchVC: UIViewController {
    
    var selectionHandler: ((SearchPlaceModel) -> Void)?

    @IBOutlet weak var fromTextField:InputTextField!
    @IBOutlet weak var placeTableView:UITableView!

    var fromPlace:SearchPlaceModel?
    var searchPlaces:[SearchPlaceModel] = []
   // var delegate:PickupLocationVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.placeTableView.register(UINib(nibName: "PlaceCell", bundle: Bundle.main), forCellReuseIdentifier: "PlaceCell")
        
        placeTableView.estimatedRowHeight = 44.0
        placeTableView.rowHeight = UITableViewAutomaticDimension
        placeTableView.tableFooterView = UIView()
        
        placeTableView?.delegate = self
        placeTableView?.dataSource = self
        fromTextField?.delegate = self
        
        self.placeTableView?.layer.borderColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        self.placeTableView?.layer.borderWidth = 1
        self.placeTableView?.layer.cornerRadius = 2
        
        placeTableView?.layer.masksToBounds = true
        placeTableView?.layer.shadowColor = UIColor.init(red: 230/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        placeTableView?.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        placeTableView?.layer.shadowOpacity = 0.3
        
        self.searchPlaces = []
        self.placeTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let fp = self.fromPlace, let fpsf = fp.strFormat?.main_text else {
            return
        }
        GMSAPIManager.manager.getPlaces(searchString: fpsf) { (status, searchPlaces, msg) in
            self.searchPlaces = []
            self.searchPlaces = searchPlaces
            self.placeTableView.reloadData()
        }
    }
    @IBAction func doneAction(_ sender:UIButton){
        
        if let handler = self.selectionHandler {
            guard let sp = self.fromPlace else{
                  self.navigationController?.popViewController(animated: true)

                return
            }
             handler(sp)
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    @IBAction func submitButtonAction(sender:UIButton){
        var msg = ""
    
        guard let place = self.fromPlace else {
            return
        }
        
        GMSAPIManager.manager.getPlaceDetail(place: place) { (status, spd, msg) in
            if let sp:SearchPlaceDetailModel = spd, let addess = sp.formatted_address, let loc = sp.geometry?.location {
                let pl =  PNDPlace(addr: self.fromPlace?.strFormat?.fullDisplayName() ?? addess, cord: CLLocationCoordinate2D.init(latitude: loc.lat!, longitude: loc.lng!))
                
                APIManager.manager.uploadAdd(category: (self.selectedCategory?.category_id)!, address: pl, dealer: self.dealershipTextField.text!, make: self.makeTextField.text!, model: self.modelTextField.text!, selectedImage: self.selectedImage, withCompletionHandler: { (responstype,msg) in
                    
                    if responstype == .invalid {
                        SVProgressHUD.showSuccess(withStatus: msg ?? "")
                        
                        let sb:UIStoryboard = UIStoryboard.init(name: "Auth", bundle: Bundle.main)
                        
                        let uploadvc:LoginVC = sb.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        self.navigationController?.pushViewController(uploadvc, animated: false)
                        //
                    }
                    else if responstype == .success{
                        SVProgressHUD.showSuccess(withStatus: API_STRING.POST_ADD_SUCCESS)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        SVProgressHUD.showError(withStatus: API_STRING.POST_ADD_FAIL)
                        
                    }
                    
                })
            }
        }
    }
}
  */
}


import GooglePlaces
import CoreLocation
import SVProgressHUD
/*
class PNDPlace {
    var address:String
    var coordinate:CLLocationCoordinate2D
    
    init(addr:String, cord:CLLocationCoordinate2D) {
        self.address = addr
        self.coordinate = cord
    }
}

protocol PickupLocationVCDelegate {
    func popupWith(from:PNDPlace, to: PNDPlace)
}
*/
extension LocationSearchVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PlaceCell = self.placeTableView.dequeueReusableCell(withIdentifier:"PlaceCell") as! PlaceCell
        
        let place:SearchPlaceModel = self.searchPlaces[indexPath.row]
        cell.fillMenuInfo(place)
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place:SearchPlaceModel = searchPlaces[indexPath.row]
        guard let str  = place.strFormat else { return  }
        
        self.fromTextField.text = str.displayName()
        self.fromPlace = place
    }
}

extension LocationSearchVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        
        GMSAPIManager.manager.getPlaces(searchString: textField.text!/*, currentLat: currLat,currentLng: currLng*/) { (status, searchPlaces, msg) in
            self.searchPlaces = []
            self.searchPlaces = searchPlaces
            self.placeTableView.reloadData()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
    }
}



