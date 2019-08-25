//
//  HomeVC.swift
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import DrawerController
import SVProgressHUD

extension UIViewController {
    
    @objc @IBAction func goBack(sender: AnyObject) {
        if let nav = navigationController {
            // If in a nav stack, pop me out
            if let index = nav.viewControllers.index(of: self), index > 0 {
                nav.popViewController(animated: true)
            }
            
            // If presented along with a nav, dismiss the nav
            else if nav.presentingViewController != nil {
                nav.dismiss(animated: true, completion: { 
                    
                })
            }
        }
        // If simply presenting, dismiss me
        else if presentingViewController != nil {
            dismiss(animated: true, completion: {
            })
        }
    }
    
    /*
    func setRDBackButton(backAction:Selector = #selector(UIViewController.goBack(_:))) {
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 40, height: 30)))
        button.setImage(UIImage(named: "rocketIcon"), forState: .Normal)
        button.addTarget(self, action: backAction, forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    */
  
    @IBAction func leftButtonAction(sender: AnyObject) {
        
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }
    
    
    func setBackButton()  {
        let backBtn = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(goBack))
        backBtn.tintColor = .white
        navigationItem.leftBarButtonItem = backBtn
    }
    
    func setMenuButton(menuAction:Selector = #selector(UIViewController.leftButtonAction(sender:))) {
        
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 40, height: 30)))
        
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: menuAction, for: .touchUpInside)
        button.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
 /*
    func setTitleView(titleImage titleImage:UIImage) {
        var titleView = navigationItem.titleView as? TitleView
        if titleView == nil {
            titleView = TitleView(frame: CGRect(x: 0, y: 0, width: navigationController?.view.frame.width ?? 320, height: navigationController?.navigationBar.frame.height ?? 44))
            navigationItem.titleView = titleView
        }
        
        titleView?.titleImageView.image = titleImage
    }
 */
   
    func showAlert(title:String, message:String, okButtonTitle:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfimationAlert(_ msg:String){
        let alertVC = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (aciton) in
            self.dismiss(animated: true, completion: nil)
            
        })
        
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension UIViewController{
    func showStatus(_ sts:Bool,msg:String?)  {
        if sts{
            SVProgressHUD.showSuccess(withStatus: msg ?? "")
        }
        else{
            SVProgressHUD.showError(withStatus:msg ?? "")
        }
    }
}
