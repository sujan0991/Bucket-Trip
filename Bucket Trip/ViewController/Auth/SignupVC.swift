//
//  SignupVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 25/5/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SVProgressHUD
import ViewUtils
import SnapKit

class SignupVC: UIViewController {
    @IBOutlet var userNameTextField:InputTextField!
    @IBOutlet var fullNameTextField:InputTextField!
    @IBOutlet var passwordTextField:InputTextField!
    @IBOutlet var emailTextField:InputTextField!
    
    @IBOutlet var countryLabel:UILabel!
    @IBOutlet var countryCodeLabel:UILabel!
    @IBOutlet var countryImageView:UIImageView!
    @IBOutlet var mobileNumberTextField:UITextField!

    @IBOutlet var forgotPasswordButton:UIButton!
    @IBOutlet var loginButton:UIButton!
    @IBOutlet var facebookButton:UIButton!
    @IBOutlet var googleButton:UIButton!
    @IBOutlet var signupButton:UIButton!
    
    @IBOutlet var countryContainerView:UIView!

    var countries:[CountryModel] = []
    var selectedCountry:CountryModel?

    lazy var modelPopup: ModelPopupView = {
        let mod:ModelPopupView = ModelPopupView.instance(withNibName: "ModelPopupView", bundle: Bundle.main, owner: self) as! ModelPopupView
        return mod
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    @IBAction func loginAction(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signupAction(_ sender:UIButton){
        let vmsg = ValidationManager.manager.validateRegisterForm(userName: userNameTextField.text!, fullName: fullNameTextField.text!, email: emailTextField.text!, password:passwordTextField.text!,country:selectedCountry,phone:mobileNumberTextField.text!)
        if !vmsg.isEmpty{
            showConfimationAlert(vmsg)
            return
        }
        
        APIManager.manager.register(userName: userNameTextField.text!, fullName: fullNameTextField.text!, email: emailTextField.text!, country: countryLabel.text!, phone: mobileNumberTextField.text!, password: passwordTextField.text!) { (status, token, msg) in
            if status{
                SVProgressHUD.showSuccess(withStatus: msg)
                AppSessionManager.shared.authToken = token
                AppSessionManager.shared.save()
                self.performSegue(withIdentifier: "SuggesstedFriendVC", sender: self)
            }
            else{
                SVProgressHUD.showError(withStatus: msg)
            }
        }
       
        //self.performSegue(withIdentifier: "SuggesstedFriendVC", sender: self)

    }
}

extension SignupVC:ModelPopupViewDelegate{
    func didSelectModel(_ model: CountryModel) {
        selectedCountry = model
        self.countryLabel.text = model.name ?? ""
        self.countryCodeLabel.text = model.phoneCode ?? ""
        let urlStr = "\(API_K.BaseUrlStr)public/images/country-with-flag/flags/\(model.iso ?? "").png"
        self.countryImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)

    }
}
