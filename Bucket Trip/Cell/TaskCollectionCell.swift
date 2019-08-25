//
//  CityCollectionCell.swift
//  Garndhabi
//
//  Created by Dulal Hossain on 11/11/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit

class TaskCollectionCell: UICollectionViewCell {
    
    @IBOutlet var taskImageView : RoundImageView?
    @IBOutlet var nameLabel : UILabel?
    @IBOutlet var senderLabel : UILabel?
    @IBOutlet var countryImageView : UIImageView?
    
    
    func fill(_ trip: TripModel)  {
        nameLabel?.text = trip.location_name ?? ""
        senderLabel?.text = trip.full_name ?? ""
        let urlStr = "\(API_K.BaseUrlStr)public/images/locations/\(trip.image ?? "")"
        
        self.taskImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
        
       // self.countryImageView?.kf.setImage(with: city.image?.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func fillPending(_ trip: TripModel)  {
        nameLabel?.text = trip.trip_title ?? ""
        senderLabel?.text = trip.friend_name ?? ""
        let urlStr = trip.location_image ?? ""
        
        self.taskImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
        
        let isoUrl = "\(API_K.BaseUrlStr)public/images/country-with-flag/flags/\(trip.iso ?? "").png"
        self.countryImageView?.kf.setImage(with: isoUrl.asImageResource(),placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)

    }
    
    func fillAccepted(_ trip: TripModel)  {
        nameLabel?.text = trip.trip_title ?? ""
        senderLabel?.text = trip.friend_name ?? ""
        let urlStr = trip.location_image ?? ""
        
        self.taskImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
        
         let isoUrl = "\(API_K.BaseUrlStr)public/images/country-with-flag/flags/\(trip.iso ?? "").png"
         self.countryImageView?.kf.setImage(with: isoUrl.asImageResource(),placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


