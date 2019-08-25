//
//  DoctorTableCell.Swift
//  RocketDoc
//
//  Created by Dulal Hossain on 8/22/16.
//  Copyright © 2016 Dulal Hossain. All rights reserved.
//

import UIKit

class MenuTableCell: UITableViewCell {
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!

     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var isBottomCell:Bool = false{
        didSet{
            seperatorView.isHidden = isBottomCell
        }
    }
    
    func fillMenuInfo(menu:Menu)  {
        self.menuLabel.text = menu.title
        menuImageView.image = UIImage.init(named: menu.icon ?? "")
        self.needsUpdateConstraints()
        
        self.setNeedsLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 }
