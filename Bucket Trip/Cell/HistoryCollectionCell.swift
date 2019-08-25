//
//  CityCollectionCell.swift
//  Garndhabi
//
//  Created by Dulal Hossain on 11/11/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit

class HistoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet var cityImageView : UIImageView?
    @IBOutlet var nameLabel : UILabel?
    @IBOutlet var countryLabel : UILabel?
    @IBOutlet var titleLabel : UILabel?
    // @IBOutlet var container : UIImageView?
    func fill(_ blog:BlogModel)  {
        
        nameLabel?.text = blog.creator_name ?? ""
        countryLabel?.text = blog.creator_country ?? ""
        titleLabel?.text = blog.blog_title ?? ""
        
        if blog.video != nil{
            
            let urlStr = "\(blog.image ?? "")"
            self.cityImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
            
        }else{
            
            let urlStr = "\(API_K.BaseUrlStr)public/images/blog/\(blog.image ?? "")"
            
            
            self.cityImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
        }


    }
    
    
    func fill(_ blog:BlogHistoryModel)  {
        if blog.isFeedBack{
            
            nameLabel?.text = blog.full_name ?? ""
            countryLabel?.text = blog.location_name ?? ""
            titleLabel?.text = blog.trip_title ?? ""
            
            if blog.video != nil{
                
                let urlStr = "\(blog.image ?? "")"
                self.cityImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
                
            }else{
                
               let urlStr = "\(API_K.BaseUrlStr)public/images/locations/\(blog.image ?? "")"
               self.cityImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            print("if.........")
        }
        else{
            
            print("else")
            
            nameLabel?.text = blog.creator_name ?? ""
            countryLabel?.text = blog.creator_country ?? ""
            titleLabel?.text = blog.blog_title ?? ""
            
            if blog.video != nil{
                
                let urlStr = "\(blog.image ?? "")"
                self.cityImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
                
            }else{

                let urlStr = "\(API_K.BaseUrlStr)public/images/blog/\(blog.image ?? "")"
            
            
                self.cityImageView?.kf.setImage(with: urlStr.asImageResource(),placeholder: UIImage.init(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class CicleImageView: UIImageView {
    
    //---------------------------------------------------
    // MARK: - Initializations
    //---------------------------------------------------
    
    func commonInit() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //---------------------------------------------------
    // MARK: - Layout
    //---------------------------------------------------
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width/2
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0.0
        layer.masksToBounds = true
    }
    
}

