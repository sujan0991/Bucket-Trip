//
//  TaskVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SVProgressHUD

enum SelectionType {
    case photo
    case video
}

class TaskVC: UIViewController {
    
    var imagePicker = UIImagePickerController()
    var selectedImage:UIImage?
    var videoURL:URL?
    var selectedTrip:TripModel?
    @IBOutlet var taskDetailLabel:UILabel!

    var selecttionType:SelectionType = .photo
    override func viewDidLoad() {
        super.viewDidLoad()
        selecttionType = .photo
        taskDetailLabel.text = ""

        guard let st = selectedTrip else{
            return
        }
        let tasks = st.tasks
        if tasks.count == 0 {
            return
        }
       
        taskDetailLabel.text = tasks[0].task_description ?? ""

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "UploadVideoVC"{
            let dest:UploadVideoVC = segue.destination as! UploadVideoVC
            dest.videoURL = videoURL
            dest.selectedTrip = selectedTrip

        }
        if segue.identifier == "UploadImageVC"{
            let dest:UploadImageVC = segue.destination as! UploadImageVC
            dest.selectedImage = selectedImage
            dest.selectedTrip = selectedTrip
        }
    }
    
    
    @IBAction func uploadImageAction(_ sender:UIButton){
        selecttionType = .photo
        showPhotoActionSheet(msg: "Choose Photo From", title: "")
    }
    
    @IBAction func uploadVideoAction(_ sender:UIButton){
        selecttionType = .video
        showPhotoActionSheet(msg: "Choose Video From", title: "")
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


extension TaskVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func showPhotoGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            if selecttionType == .video{
                self.imagePicker.mediaTypes = ["public.movie"]
            }
            else{
                
            }
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    func showCameraGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            if selecttionType == .video{
                self.imagePicker.mediaTypes = ["public.movie"]
            }
          
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if selecttionType == .photo{
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            selectedImage = chosenImage
            self.performSegue(withIdentifier: "UploadImageVC", sender: self)
        }
        else{
            videoURL = info[UIImagePickerControllerMediaURL] as? URL
            self.performSegue(withIdentifier: "UploadVideoVC", sender: self)
        }

        picker.dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {}
    }
}
