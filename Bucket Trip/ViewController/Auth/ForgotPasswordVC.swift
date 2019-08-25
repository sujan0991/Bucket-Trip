//
//  ForgotPasswordVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 25/5/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordVC: UIViewController {
    @IBOutlet var emailTextField:InputTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func resetPasswordAction(_ sender:UIButton){
        let vMsg = ValidationManager.manager.validateForgotPasswordForm(email: emailTextField.text!)
        if !vMsg.isEmpty{
            showConfimationAlert(vMsg)
            return
        }
        APIManager.manager.getOtp(email: emailTextField.text!) { (status, msg) in
            if status{
                SVProgressHUD.showSuccess(withStatus: msg)
                self.performSegue(withIdentifier: "ResetPasswordVC", sender: self)
            }
            else{
                SVProgressHUD.showError(withStatus: msg ?? "")
            }
        }
    }
}
