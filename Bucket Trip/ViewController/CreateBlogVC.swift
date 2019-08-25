//
//  CreateBlogVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 8/8/18.
//  Copyright © 2018 DL. All rights reserved.
//


import UIKit
import GooglePlaces
import CoreLocation
import SVProgressHUD
import MobileCoreServices
import MediaPlayer
import AVKit


enum MediaType {
    
    case photo
    case video
}
class CreateBlogVC: UIViewController {
    
    @IBOutlet var tripTitleTextField:InputTextField!
    @IBOutlet var tripDriptionTextField:RoundTextView!
    @IBOutlet var blogImageView:UIImageView!

    @IBOutlet weak var videoView: UIView!
    
    
    @IBOutlet var photoVideoSegment:UISegmentedControl!
    @IBOutlet var mediaButton:UIButton!

    let videoPlayerController = AVPlayerViewController()
    
    var mediaType: MediaType = .photo{
        didSet{
            let mediaName:String = mediaType == .photo ? "camera":"video"
            let mediaImage:UIImage = UIImage.init(named: mediaName)!
            mediaButton.setImage(mediaImage, for: .normal)
        }
    }
    
    var blogImage:UIImage?
    var videoPath:URL?

    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        mediaType = .photo
        videoView.isHidden = true
        
        let tapG:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(addPhoto(_:)))
        tapG.numberOfTapsRequired = 1
        tapG.numberOfTouchesRequired = 1
        blogImageView?.isUserInteractionEnabled = true
        blogImageView?.addGestureRecognizer(tapG)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectMedia(_ sender:UISegmentedControl){
        
        mediaType = sender.selectedSegmentIndex == 0 ? .photo:.video
        
        if mediaType == .photo{
            
           videoView.isHidden = true
           blogImageView.isHidden = false
        }else{
            
            videoView.isHidden = false
            blogImageView.isHidden = true
        }
    }
    @IBAction func createTrip(_ sender:UIButton){
        
        print("mediaType" ,mediaType)
        
        let vMsg = ValidationManager.manager.validateCreateBlogForm(title: tripTitleTextField.text!, details: tripDriptionTextField.text!, image: blogImage , videopath : self.videoPath )
        
        if !vMsg.isEmpty{
            showConfimationAlert(vMsg)
            return
        }
        
        //if upload with photo
        if blogImage != nil {
        
            APIManager.manager.uploadBlogImage(blogImage) { (status,url, msg) in
                if status{
                    APIManager.manager.createBlog(title: self.tripTitleTextField.text!, details: self.tripDriptionTextField.text!, imageUrl: url, videoUrl: nil, withCompletionHandler: { (sts, msg) in
                        
                        self.showStatus(status, msg: msg ?? "")
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else{
                    
                    SVProgressHUD.showError(withStatus: msg ?? "")
                }
            }
        }else{
            //if upload with video
            print("videoURL", videoPath!)
            
            APIManager.manager.uploadBlogVideo(videoPath) { (status, url,thumburl, msg) in
                
                if status{
                    APIManager.manager.createBlog(title: self.tripTitleTextField.text!, details: self.tripDriptionTextField.text!, imageUrl: thumburl, videoUrl: url, withCompletionHandler: { (sts, msg) in
                        
                        self.showStatus(status, msg: msg ?? "")
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else{
                    
                    SVProgressHUD.showError(withStatus: msg ?? "")
                }
                
            }
            
        }
        

    }
    
    @IBAction func addPhoto(_ sender:UIButton){
        if mediaType == .photo{
            showPhotoActionSheet(msg: "Choose Photo From", title: "Add blog photo")
            return
        }
        showPhotoActionSheet(msg: "Choose Video From", title: "Add blog Video")
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


extension CreateBlogVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func showPhotoGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            if mediaType == .video{
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.imagePicker.mediaTypes = [kUTTypeMovie as String]

                self.imagePicker.delegate = self
            }
            else{
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                self.imagePicker.allowsEditing = false
            }
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    func showCameraGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if mediaType == .video{
                self.imagePicker.sourceType = .camera
                self.imagePicker.mediaTypes = [kUTTypeMovie as String]
                self.imagePicker.delegate = self
                self.imagePicker.videoMaximumDuration = 10.0
            }
            else{
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                self.imagePicker.allowsEditing = false

            }          
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        else {
            print("Camera is not available")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if mediaType == .photo{
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            blogImageView.image = chosenImage
            blogImage = chosenImage
        }
        else{
           // let mediaType2 = info[UIImagePickerControllerMediaType] as! NSString
            self.videoPath = info[UIImagePickerControllerMediaURL] as? URL
            
            
            videoPlayerController.showsPlaybackControls = true
            videoPlayerController.player = AVPlayer(url: self.videoPath!)
            videoView.addSubview(videoPlayerController.view)
            
            videoPlayerController.view.frame = videoView.bounds
            videoPlayerController.player?.play()

            
        }
       
        picker.dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {}
    }
}

