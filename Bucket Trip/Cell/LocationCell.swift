//
//  LocationCell.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet var tripImageView:RoundImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    
    @IBOutlet var tickButton:TickButton!

    var isTicked:Bool = false{
        didSet{
            
            tickButton.setImage(UIImage.init(named: isTicked ? "tick":""), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isTicked = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillLocation(_ location:LocationModel) {
        nameLabel.text = location.location_name
        dateLabel.text = location.name
        let urlStr = "\(API_K.BaseUrlStr)public/images/locations/thumb/\(location.image ?? "")"

        self.tripImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
    }
}

class TickButton: UIButton {
}
