//
//  TaskTableCell.Swift
//  RocketDoc
//
//  Created by Dulal Hossain on 8/22/16.
//  Copyright © 2016 Dulal Hossain. All rights reserved.
//

import UIKit

class TaskTableCell: UITableViewCell {
    @IBOutlet weak var textField: RoundTextField!

     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fillInfo(menu:String)  {
        self.textField.text = menu
        self.needsUpdateConstraints()
        self.setNeedsLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 }
