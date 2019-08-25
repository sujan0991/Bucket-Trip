//
//  ProfileVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 30/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

enum PictureSelectType {
    case coverphoto
    case profilepicture
    
}

class ProfileVC: UIViewController {

    @IBOutlet var timelineImageView:UIImageView!
    @IBOutlet var profileImageView:CircularImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var countyLabel:UILabel!
    @IBOutlet var aboutMeLabel:UILabel!
    @IBOutlet var emailLabel:UILabel!
    @IBOutlet var phoneLabel:UILabel!

    var pictureSelection:PictureSelectType = .profilepicture
    
    var imagePicker = UIImagePickerController()

    var user:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureSelection = .profilepicture
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.manager.getMyProfile { (status, um, msg) in
            if status{
                if let u = um{
                    self.user = u
                    self.fill(u)
                }
            }
            else{
                self.showStatus(status, msg: msg)
            }
        }

    }

    func fill(_ um:UserModel)  {
        aboutMeLabel.text = um.about_me ?? ""
        nameLabel.text = um.full_name ?? ""
        countyLabel.text = um.country ?? ""
        emailLabel.text = um.email ?? ""
        phoneLabel.text = um.phone ?? ""
        let urlStr = "\(API_K.BaseUrlStr)public/images/users/\(um.avatar ?? "")"
        self.profileImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)

        let urlTStr = "\(API_K.BaseUrlStr)public/images/users/\(um.cover_photo ?? "")"
        self.timelineImageView?.kf.setImage(with: urlTStr.asImageResource(),placeholder: UIImage.init(named: "td"), options: nil, progressBlock: nil, completionHandler: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfileVC"{
            let evc = segue.destination as! EditProfileVC
            evc.user = self.user
        }
        if segue.identifier == "BlogPostVC"{
            let evc = segue.destination as! BlogPostVC
            evc.blogType = .mine
        }
    }
    
    @IBAction func travelHistoryAction(_ sender:UIButton){
        self.performSegue(withIdentifier: "MyTravelHistoryVC", sender: self)
    }
    
    @IBAction func blogPostAction(_ sender:UIButton){
        self.performSegue(withIdentifier: "BlogPostVC", sender: self) 
    }

    @IBAction func editProfilePicture(_ sender:UIButton){
        pictureSelection = .profilepicture

        showPhotoActionSheet(msg: "Choose Photo From", title: "Update Profile Picture")
    }
    
    @IBAction func editCoverPhoto(_ sender:UIButton){
        pictureSelection = .coverphoto

        showPhotoActionSheet(msg: "Choose Photo From", title: "Update Cover Photo")
    }
    
    @IBAction func dotMenuAction(_ sender:UIButton){
        self.performSegue(withIdentifier: "EditProfileVC", sender: self)
    }

    func showPhotoActionSheet(msg:String, title:String){
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Camera", style: .default, handler: { (aciton) in
            self.showCameraGallery()
        })
        let cameraAction = UIAlertAction(title: "Gallery", style: .default, handler: { (aciton) in
            self.showPhotoGallery()
        })
        
        let galleryAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (aciton) in
            self.dismiss(animated: true, completion: nil)
        })
        alertVC.addAction(okAction)
        alertVC.addAction(cameraAction)
        alertVC.addAction(galleryAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}



extension ProfileVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func showPhotoGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    func showCameraGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        if pictureSelection == .profilepicture{
            profileImageView.image = chosenImage
        }
        else{
            timelineImageView.image = chosenImage
        }
        APIManager.manager.upload(chosenImage,type: pictureSelection) { (rt, msg) in
            if rt{
                SVProgressHUD.showSuccess(withStatus: msg ?? "")
            }
            else{
                SVProgressHUD.showError(withStatus: msg ?? "")
            }
        }
        picker.dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {}
    }
}
