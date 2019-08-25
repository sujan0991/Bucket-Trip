//
//  PreviewVC.swift
//  Bucket Trip
//
//  Created by Md.Ballal Hossen on 13/11/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import AudioToolbox

class PreviewVC: UIViewController,AVPlayerViewControllerDelegate {

    var selectedBlogfromHistory:BlogHistoryModel?
    var selectedBlog:BlogModel?
    var videoUrlStr :String?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var blogImage: UIImageView!
    
    @IBOutlet weak var travellerNameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var blogTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let bh = selectedBlogfromHistory{
            populateViewforHistory(bh)
        }
        
        guard let bl = selectedBlog else {
            return
        }
        populateView(bl)

      
        
    }
    
    
    func populateViewforHistory(_ blog:BlogHistoryModel) {
        
        
        
        travellerNameLabel.text = blog.creator_name ?? ""
        timeLabel.text = Date().offset(from: (blog.created_at?.toDateTime())!)
        blogTitleLabel.text = blog.blog_title ?? ""
        
        if blog.video != nil {
            
            self.blogImage.isHidden = false;
            playButton.isHidden = false
            videoUrlStr = "\(blog.video ?? "")"
            
            let urlStr = "\(blog.image ?? "")"
            self.blogImage?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
            
            print("urlStr  : ",urlStr);

        }else{
            
            playButton.isHidden = true
            blogImage.isHidden = false
            let urlStr = "\(API_K.BaseUrlStr)public/images/blog/\(blog.image ?? "")"
            self.blogImage?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
            print("urlStr only image : ",urlStr);
        }

       
        
    }
    
    func populateView(_ blog:BlogModel) {
        
        //NSLog("blog_title %@", blog.blog_title ?? "no title")
        
        travellerNameLabel.text = blog.creator_name ?? ""
        timeLabel.text = Date().offset(from: ((blog.created_at?.toDateTime())!)) 
        blogTitleLabel.text = blog.blog_title ?? ""
        
        if blog.video != nil {
            
            self.blogImage.isHidden = false;
            playButton.isHidden = false
            videoUrlStr = "\(blog.video ?? "")"
            
            let urlStr = "\(blog.image ?? "")"
            self.blogImage?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
            
            print("urlStr  : ",urlStr);
            
            
            
        }else{
            
            playButton.isHidden = true
            blogImage.isHidden = false
            let urlStr = "\(API_K.BaseUrlStr)public/images/blog/\(blog.image ?? "")"
            self.blogImage?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
            print("urlStr only image : ",urlStr);
        }
        
        
    }

    @IBAction func playButtonAction(_ sender: Any) {
        
        if let videoURL = URL(string: videoUrlStr!)
        {
            let player = AVPlayer(url: videoURL)
            let playervc = AVPlayerViewController()
            //playervc.delegate = self
            playervc.player = player
            self.present(playervc, animated: true) {
                playervc.player!.play()
            }

        }
        
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
