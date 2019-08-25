//
//  UploadImageVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SVProgressHUD

class UploadImageVC: UIViewController {

    @IBOutlet var taskImageView:UIImageView?
    
    var selectedImage:UIImage?
    var imagePicker = UIImagePickerController()
    var selectedTrip:TripModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let si = selectedImage else {
            return
        }
        taskImageView?.image = si
        let tapG:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(changePhoto(_:)))
        tapG.numberOfTapsRequired = 1
        tapG.numberOfTouchesRequired = 1
        taskImageView?.isUserInteractionEnabled = true
        taskImageView?.addGestureRecognizer(tapG)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePhoto(_ sender:UITapGestureRecognizer){
        showPhotoActionSheet(msg: "Choose Photo From", title: "")
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
    
    @IBAction func uploadPhoto(_ sender:UIButton){
        guard let si = selectedTrip else {
            return
        }
        if si.tasks.count == 0 {
            return
        }
        let task = si.tasks[0]
        guard let task_id = task.task_id else{return}
        
        APIManager.manager.uploadTaskPhoto(selectedImage,taskId:task_id) { (rt, msg) in
            if rt{
                SVProgressHUD.showSuccess(withStatus: msg ?? "")
                self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                SVProgressHUD.showError(withStatus: msg ?? "")
            }
        }
    }

}

extension UploadImageVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
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
        selectedImage = chosenImage
        taskImageView?.image = chosenImage
        
        picker.dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {}
    }
}

