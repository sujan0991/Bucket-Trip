//
//  HomeMenuView.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 15/8/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class HomeMenuView: UIView {

    var passportHandler: (() -> Void)?
    var acceptedTasksHandler: (() -> Void)?
    var pendingTasksHandler: (() -> Void)?
    var friendsHandler: (() -> Void)?
    var tripLocationHandler: (() -> Void)?


    @IBAction func passportAction(_ sender:UIButton){
        if let handler = self.passportHandler{
            handler()
        }
    }
    
    @IBAction func acceptedTasksAction(_ sender:UIButton){
        if let handler = self.acceptedTasksHandler{
            handler()
        }
    }
    @IBAction func pendingTasksAction(_ sender:UIButton){
        if let handler = self.pendingTasksHandler{
            handler()
        }
    }
    @IBAction func friendsAction(_ sender:UIButton){
        if let handler = self.friendsHandler{
            handler()
        }
    }
    @IBAction func tripLocationAction(_ sender:UIButton){
        if let handler = self.tripLocationHandler{
            handler()
        }
    }
}
