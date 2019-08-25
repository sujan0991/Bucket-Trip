//
//  CityCollectionCell.swift
//  Garndhabi
//
//  Created by Dulal Hossain on 11/11/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit

class PassportCollectionCell: UICollectionViewCell {
    
    @IBOutlet var taskImageView : UIImageView?
    @IBOutlet var nameLabel : UILabel?
    @IBOutlet var senderLabel : UILabel?
    @IBOutlet var countryImageView : UIImageView?
    
    func setInfo(_ trip:TripModel)  {
        self.nameLabel?.text = trip.friend_name ?? ""
        self.senderLabel?.text = trip.friend_country
        
        let urlStr = "\(API_K.BaseUrlStr)public/images/locations/\(trip.location_image ?? "")"
        
        self.taskImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
        
        
        let urlSt = "\(API_K.BaseUrlStr)public/images/users/\(trip.avatar ?? "")"
        self.countryImageView?.kf.setImage(with: urlSt.asImageResource(),placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        
        self.needsUpdateConstraints()
        self.setNeedsLayout()
    }

    /*
    func setImage(_ city: String)  {
        nameLabel?.text = ""
        senderLabel?.text = ""
        self.taskImageView?.kf.setImage(with: city.image?.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
        self.countryImageView?.kf.setImage(with: city.image?.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
    }*/
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


