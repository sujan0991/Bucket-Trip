//
//  EditProfileVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 10/8/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

import SVProgressHUD
import ViewUtils
import SnapKit

class EditProfileVC: UIViewController {
    @IBOutlet var fullNameTextField:RoundTextField!
    @IBOutlet var aboutMeTextView:RoundTextView!
    @IBOutlet var countryLabel:UILabel!
    @IBOutlet var countryCodeLabel:UILabel!
    @IBOutlet var countryImageView:UIImageView!
    @IBOutlet var mobileNumberTextField:UITextField!
    
    @IBOutlet var countryContainerView:UIView!

    var countries:[CountryModel] = []
    var selectedCountry:CountryModel?
    var user:UserModel?
    
    lazy var modelPopup: ModelPopupView = {
        let mod:ModelPopupView = ModelPopupView.instance(withNibName: "ModelPopupView", bundle: Bundle.main, owner: self) as! ModelPopupView
        return mod
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let usr = self.user else { return  }
        fill(usr)
    }
    
    func  fill(_ user:UserModel) {
        fullNameTextField.text = user.full_name ?? ""
        aboutMeTextView.text = user.about_me ?? ""
        countryLabel.text = user.country ?? ""
       // countryCodeLabel.text = user.ph ?? ""
       // let urlStr = "\(API_K.BaseUrlStr)public/images/country-with-flag/flags/\(user.iso ?? "").png"
       // self.countryImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)

        mobileNumberTextField.text = user.phone ?? ""
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.manager.getCountryList { (conts) in
            self.countries = conts
        }
    }
    
    @IBAction func selectCountryAction(_ sender:UIButton){
        if countries.count == 0 {
            APIManager.manager.getCountryList { (conts) in
                self.countries = conts
                self.addPopup()
            }
        }
        else{
            addPopup()
        }
    }
    
    func addPopup()  {
        
        self.view.addSubview(modelPopup)
        modelPopup.delegate = self
        modelPopup.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(55+countryContainerView.frame.maxY + countryContainerView.frame.height)
            
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            
            make.height.equalTo(200)
        }
        modelPopup.models = self.countries
        modelPopup.tableView.reloadData()
    }
    
    
    @IBAction func submitAction(_ sender:UIButton){

        let vmsg = ValidationManager.manager.validateEditProfileForm(fullName: fullNameTextField.text!,country:selectedCountry,aboutme:aboutMeTextView.text!)
        if !vmsg.isEmpty{
            showConfimationAlert(vmsg)
            return
        }
        
        APIManager.manager.updateProfile(fullName: fullNameTextField.text!, country: countryLabel.text!, phone: mobileNumberTextField.text!, aboutme: aboutMeTextView.text!) { (status, token, msg) in
            if status{
                SVProgressHUD.showSuccess(withStatus: msg)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                SVProgressHUD.showError(withStatus: msg)
            }
        }
    }
}

extension EditProfileVC:ModelPopupViewDelegate{
    func didSelectModel(_ model: CountryModel) {
        selectedCountry = model
        self.countryLabel.text = model.name ?? ""
        self.countryCodeLabel.text = model.phoneCode ?? ""
        let urlStr = "\(API_K.BaseUrlStr)public/images/country-with-flag/flags/\(model.iso ?? "").png"
        self.countryImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
    }
}
