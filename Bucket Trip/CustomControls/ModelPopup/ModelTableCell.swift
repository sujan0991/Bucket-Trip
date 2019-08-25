//
//  DoctorTableCell.Swift
//  RocketDoc
//
//  Created by Dulal Hossain on 8/22/16.
//  Copyright © 2016 Dulal Hossain. All rights reserved.
//

import UIKit

class ModelTableCell: UITableViewCell {
    
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var showIcon:Bool = false{
        didSet{
           // imgView.isHidden = !showIcon
        }
    }

     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillModelInfo(_ model:CountryModel)  {
        self.menuLabel.text = model.name
        let urlStr = "\(API_K.BaseUrlStr)public/images/country-with-flag/flags/\(model.iso ?? "").png"
        self.imgView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTransparent() {
        let bgView: UIView = UIView()
        bgView.backgroundColor = .clear
        
        self.backgroundView = bgView
        self.backgroundColor = .clear
    }
 }
