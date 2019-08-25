//
//  LoginVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 25/5/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SVProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import Firebase
import GoogleSignIn


class LoginVC: UIViewController,GIDSignInUIDelegate {

    @IBOutlet var userNameTextField:InputTextField!
    @IBOutlet var passwordTextField:InputTextField!
    
    @IBOutlet var forgotPasswordButton:UIButton!
    @IBOutlet var loginButton:UIButton!
    @IBOutlet var facebookButton:UIButton!
    @IBOutlet var signupButton:UIButton!
    @IBOutlet var googleButton:GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.text = "dulal0026"
        passwordTextField.text = "Password123"
        
        NotificationCenter.default.addObserver(self, selector: #selector(googleSignin(notification:)), name: NSNotification.Name(rawValue: "GoogleSignIn"), object: nil)
    }
    @objc func googleSignin(notification: NSNotification) {
        if let dict = notification.userInfo{
            APIManager.manager.login(userName: dict["Name"] as! String, password: dict["uid"] as! String, loginType: 2) { (status, token, msg) in
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
           // self.fullNameTextField.text = dict["Name"] as! String
           // self.emailTextField.text = dict["Email"] as! String
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPasswordAction(_ sender:UIButton){
        self.performSegue(withIdentifier: "ForgotPasswordVC", sender: self)

    }
    @IBAction func loginAction(_ sender:UIButton){
        
        let vmsg = ValidationManager.manager.validateLoginForm(userName: userNameTextField.text!, password: passwordTextField.text!)
        if !vmsg.isEmpty{
            showConfimationAlert(vmsg)
            return
        }
        APIManager.manager.login(userName: userNameTextField.text!, password: passwordTextField.text!, loginType: 0) { (status, token, msg) in
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
    }
   
    @IBAction func facebookLoginAction(sender:UIButton) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        // Extend the code sample from 6a. Add Facebook Login to Your Code
        // Add to your viewDidLoad method:
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        // fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict : [String : AnyObject] = result as! [String : AnyObject]
                    print(result!)
                    print(dict)
                   // self.fullNameTextField.text = (dict["name"] as! String)
                    if let name:String = dict["name"] as? String {
                      //  self.emailTextField.text = email
                        APIManager.manager.login(userName:name, password: dict["id"] as! String, loginType: 1) { (status, token, msg) in
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
                    }
                    
                }
            })
        }
    }
    @IBAction func googleLoginAction(_ sender:UIButton){
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func signupAction(_ sender:UIButton){
        self.performSegue(withIdentifier: "SignupVC", sender: self)
    }
}
