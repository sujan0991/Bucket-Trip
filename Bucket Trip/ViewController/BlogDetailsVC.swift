//
//  BlogDetailsVC.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 17/8/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit
import SVProgressHUD


class BlogDetailsVC: UIViewController {
    
    @IBOutlet var blogTitleLabel:UILabel!
    @IBOutlet var blogDetailLabel:UILabel!
    @IBOutlet var blogImageView:UIImageView!
    var selectedBlog:BlogModel?
    var selectedBlogHistory:BlogHistoryModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        blogImageView.isUserInteractionEnabled = true
        blogImageView.addGestureRecognizer(tapGestureRecognizer)
        
        if let bh = selectedBlogHistory{
            fillBlogHistory(bh)
        }
        guard let bl = selectedBlog else {
            return
        }
        fill(bl)
    }
    
    func fillBlogHistory(_ blog:BlogHistoryModel)  {
        blogTitleLabel?.text = blog.blog_title ?? ""
        blogDetailLabel?.text = blog.blog_description ?? ""
        if blog.video != nil{
            
            let urlStr = "\(blog.image ?? "")"
            self.blogImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)

        }else{
            
            let urlStr = "\(blog.image ?? "")"
            self.blogImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
    }
    
    func fill(_ blog:BlogModel)  {
        
        blogTitleLabel?.text = blog.blog_title ?? ""
        blogDetailLabel?.text = blog.blog_description ?? ""
        if blog.video != nil{
            
            let urlStr = "\(blog.image ?? "")"
            self.blogImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
            
        }else{
            
            let urlStr = "\(blog.image ?? "")"
            self.blogImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //go to previewVC and pass model
        let viewController = storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as? PreviewVC

        //print("\(String(describing: selectedBlogHistory?.blog_title))")
        
        //if came from blog history
        if let bh = selectedBlogHistory{
            viewController?.selectedBlogfromHistory = bh
        }
        
        //if came from blog post
        if let bl = selectedBlog{
            
             viewController?.selectedBlog = bl
           
        }

        //print("\(viewController?.selectedBlog)")
        
        self.navigationController?.present(viewController!, animated: true, completion: nil)

        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "BlogDetailsVC"{
//            let evc = segue.destination as! BlogDetailsVC
//            evc.selectedBlog = sender as? BlogModel
//        }
//    }
    
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
   
}
