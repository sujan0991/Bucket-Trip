//
//  DoctorTableCell.Swift
//  RocketDoc
//
//  Created by Dulal Hossain on 8/22/16.
//  Copyright © 2016 Dulal Hossain. All rights reserved.
//

import UIKit

class TripInvitationCell: UITableViewCell {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!

     override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setInfo(_ trip:TripModel)  {
        self.menuLabel.text = trip.user_name
        self.countryLabel.text = trip.location_name
        self.dateLabel.text = trip.tripDate()
        self.detailsLabel.text = trip.tripDetails
      //  self.menuImageView?.kf.setImage(with: user.avatar?.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)

        self.needsUpdateConstraints()
        self.setNeedsLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

