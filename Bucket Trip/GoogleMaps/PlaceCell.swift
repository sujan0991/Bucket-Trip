//
//  DoctorTableCell.Swift
//  RocketDoc
//
//  Created by Dulal Hossain on 8/22/16.
//  Copyright © 2016 Dulal Hossain. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    func fillMenuInfo(_ place:SearchPlaceModel)  {
        guard let strcF = place.strFormat else { return  }
        nameLabel?.text = strcF.main_text ?? ""
        descriptionLabel?.text = strcF.secondary_text ?? ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 }
