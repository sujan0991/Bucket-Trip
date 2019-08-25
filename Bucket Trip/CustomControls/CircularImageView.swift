//
//  CircularImageView.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 28/5/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView{
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet { setNeedsLayout() } }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet{ setNeedsLayout() } }
    
    
    @IBInspectable var borderColor:UIColor = UIColor.clear { didSet {
        self.layer.borderColor = borderColor.cgColor
        setNeedsLayout()
        }
    }
    
    
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
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        layer.masksToBounds = true
    }
    
}
