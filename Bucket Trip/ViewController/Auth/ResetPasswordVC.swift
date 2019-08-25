//
//  ResetPasswordVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 27/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResetPasswordVC: UIViewController {
    @IBOutlet var otpTextField:InputTextField!
    @IBOutlet var passwordTextField:InputTextField!
    @IBOutlet var confirmPasswordTextField:InputTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPasswordAction(_ sender:UIButton){
        let vMsg = ValidationManager.manager.validateResetPasswordForm(otp:otpTextField.text!,password: passwordTextField.text!, confirmPassword: confirmPasswordTextField.text!)
        
        if !vMsg.isEmpty{
            showConfimationAlert(vMsg)
            return
        }
        APIManager.manager.resetPassword(otp:otpTextField.text!,password: passwordTextField.text!) { (status, msg) in
            if status{
                SVProgressHUD.showSuccess(withStatus: msg)
                self.performSegue(withIdentifier: "", sender: self)
            }
            else{
                SVProgressHUD.showError(withStatus: msg ?? "")
            }
        }
    }
}

