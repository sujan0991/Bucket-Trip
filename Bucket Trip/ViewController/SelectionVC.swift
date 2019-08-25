//
//  SelectionVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 29/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class SelectionVC: UIViewController {
    
    @IBOutlet var scTableView:UITableView!

    var locations:[LocationModel] = []
    var selectedLocation:LocationModel?
    
    var selectionHandler: ((LocationModel) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        scTableView.tableFooterView = UIView(frame: .zero)
        self.scTableView.register(UINib(nibName: "LocationCell", bundle: Bundle.main), forCellReuseIdentifier: "LocationCell")
        scTableView.delegate = self
        scTableView.dataSource = self
        self.scTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.manager.getTripLocationList { (locs) in
            self.locations = locs
            self.scTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneAction(_ sender:UIButton){
        guard let selLoc = self.selectedLocation else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        if let handler = self.selectionHandler {
            handler(selLoc)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension SelectionVC:UITableViewDelegate,UITableViewDataSource{
    
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
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"LocationCell") as! LocationCell
        cell.selectionStyle = .none;
         let match = locations[indexPath.row]
         cell.fillLocation(match)
        if let selLoc = selectedLocation{
            cell.isTicked = selLoc.location_id == match.location_id
        }
        else {
            cell.isTicked = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedLocation = locations[indexPath.row]
        self.scTableView.reloadData()
    }
}
