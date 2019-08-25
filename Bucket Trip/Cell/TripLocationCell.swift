//
//  TripLocationCell.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class TripLocationCell: UITableViewCell {

    @IBOutlet var tripImageView:RoundImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    @IBOutlet var deleteButton:UIButton!

    var handler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillTrip( _ trip:TripModel) {
        nameLabel.text = trip.location_name ?? ""
        dateLabel.text = trip.tripDate()
        let urlStr = trip.location_image ?? "" //"\(API_K.BaseUrlStr)public/images/locations/\(trip.image ?? "")"

        self.tripImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    @IBAction func deleteButtonAction(_ sender:UIButton){
        if let handle = handler{
            handle()
        }

    }
}
