//
//  DoctorTableCell.Swift
//  RocketDoc
//
//  Created by Dulal Hossain on 8/22/16.
//  Copyright © 2016 Dulal Hossain. All rights reserved.
//

import UIKit
import Kingfisher

enum AddButtonType {
    case invite
    case accept
    case friend
    case tripinvited
    case tripinvite
}

class SuggestFriendCell: UITableViewCell {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet var addFriendButton:AddButton!

    var addButtonType:AddButtonType = .invite{
        didSet{
            var buttonTitle:String = "Invite"
            var backgroundImg:String = "add_button"
            var titleColor = UIColor.white
            switch addButtonType {
            case .invite:
                buttonTitle = "Invite"
            case .accept:
                    buttonTitle = "Accept"
            case .friend:
                    buttonTitle = "Remove"
            case .tripinvited:
                buttonTitle = "Invited"
                
            case .tripinvite:
                buttonTitle = "Invite"
                backgroundImg = "added"
                titleColor = UIColor.init(red: 123/255, green: 123/255, blue: 123/255, alpha: 1)

            default:
                print("")
            }
            addFriendButton.setTitle(buttonTitle, for: .normal)
            addFriendButton.setBackgroundImage(UIImage.init(named: backgroundImg), for: .normal)
            addFriendButton.setTitleColor(titleColor, for: .normal)
        }
    }
    var addHandler: (() -> Void)?
    var profileTapHandler: (() -> Void)?

     override func awakeFromNib() {
        super.awakeFromNib()
        addButtonType = .invite
        
        let tapG:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapOnPicture(_:)))
        menuImageView.isUserInteractionEnabled = true
        tapG.numberOfTapsRequired = 1
        tapG.numberOfTouchesRequired = 1
        menuImageView.addGestureRecognizer(tapG)
    }
    
    @IBAction func tapOnPicture(_ sender:UIGestureRecognizer){
        profileTapHandler?()

    }
    
    @IBAction func addButtonAction(_ sender:UIButton){
        addHandler?()
    }
    
    func setFriendInfo(_ user:UserModel)  {
        menuLabel.text = user.full_name ?? ""
        countryLabel.text = user.country ?? ""
        let urlStr = "\(API_K.BaseUrlStr)public/images/users/\(user.avatar ?? "")"
        self.menuImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class AddButton: UIButton {
    
}
