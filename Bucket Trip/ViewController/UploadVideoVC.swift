//
//  UploadVideoVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 3/6/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SVProgressHUD
import MediaPlayer
import AVKit

class UploadVideoVC: UIViewController {
    
    var videoURL:URL?
    var selectedTrip:TripModel?

    let videoPlayerController = AVPlayerViewController()
    
    @IBOutlet weak var videoView: UIView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapG:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(changePhoto(_:)))
        tapG.numberOfTapsRequired = 1
        tapG.numberOfTouchesRequired = 1
        videoView?.isUserInteractionEnabled = true
        videoView?.addGestureRecognizer(tapG)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoPlayerController.showsPlaybackControls = true
        videoPlayerController.player = AVPlayer(url: videoURL!)
        videoView.addSubview(videoPlayerController.view)
        
        videoPlayerController.view.frame = videoView.bounds
        videoPlayerController.player?.play()
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
    
    @IBAction func uploadVideo(_ sender:UIButton){
       
        guard let si = selectedTrip else {
            return
        }
        if si.tasks.count == 0 {
            return
        }
        let task = si.tasks[0]
        guard let task_id = task.task_id else{return}
        
        APIManager.manager.uploadTaskVideo(videoURL,taskId:task_id) { (rt, msg) in
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

extension UploadVideoVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func showPhotoGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            self.imagePicker.mediaTypes = ["public.movie"]
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
        videoURL = info[UIImagePickerControllerMediaURL] as? URL

        picker.dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {}
    }
}

