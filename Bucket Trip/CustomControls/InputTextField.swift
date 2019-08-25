//
//  InputTextField.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 26/5/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class InputTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 4

    /*
    @IBInspectable var cornerRadius:CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
            layer.masksToBounds = true
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
            layer.masksToBounds = true
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    */
    @IBInspectable var enabledShaddow:Bool = false{
        didSet{
            layer.masksToBounds = false

            if enabledShaddow {
                layer.borderWidth = 1
                layer.borderColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0).cgColor

                layer.cornerRadius = 8

                layer.shadowRadius = 3.0
                layer.shadowColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0).cgColor
                layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
                layer.shadowOpacity = 1.0
            }
            else{
                layer.borderWidth = 0
                layer.cornerRadius = 8

                layer.borderColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0).cgColor
                layer.shadowRadius = 0.0
                layer.shadowColor = UIColor.clear.cgColor
                layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
                layer.shadowOpacity = 0.0
            }
            setNeedsDisplay()
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
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets.init(top: 0, left: inset, bottom: 0, right: inset)
        return UIEdgeInsetsInsetRect(bounds, insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets.init(top: 0, left: inset, bottom: 0, right: inset)
        return UIEdgeInsetsInsetRect(bounds, insets)
    }
}

//
//  InputTextField.swift
//  Bucket Trip
//
//  Created by Dulal Hossain on 26/5/18.
//  Copyright © 2018 DL. All rights reserved.
//

import UIKit

class RoundTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 4
    
    
     @IBInspectable var cornerRadius:CGFloat = 0{
     didSet{
     layer.cornerRadius = cornerRadius
     layer.masksToBounds = true
     setNeedsDisplay()
     setNeedsLayout()
     }
     }
     
     @IBInspectable var borderWidth:CGFloat = 0{
     didSet{
     layer.borderWidth = borderWidth
     layer.masksToBounds = true
     setNeedsDisplay()
     setNeedsLayout()
     }
     }
     
     @IBInspectable var borderColor:UIColor = UIColor.clear{
     didSet{
     layer.borderColor = borderColor.cgColor
     layer.masksToBounds = true
     setNeedsDisplay()
     setNeedsLayout()
     }
     }
    
    @IBInspectable var enabledShaddow:Bool = false{
        didSet{
            layer.masksToBounds = false
            
            if enabledShaddow {
                layer.borderWidth = 1
                layer.borderColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0).cgColor
                
                layer.cornerRadius = 8
                
                layer.shadowRadius = 3.0
                layer.shadowColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0).cgColor
                layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
                layer.shadowOpacity = 1.0
            }
            else{
                layer.borderWidth = 0
                layer.cornerRadius = 8
                
                layer.borderColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0).cgColor
                layer.shadowRadius = 0.0
                layer.shadowColor = UIColor.clear.cgColor
                layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
                layer.shadowOpacity = 0.0
            }
            setNeedsDisplay()
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
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets.init(top: 0, left: inset, bottom: 0, right: inset)
        return UIEdgeInsetsInsetRect(bounds, insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets.init(top: 0, left: inset, bottom: 0, right: inset)
        return UIEdgeInsetsInsetRect(bounds, insets)
    }
}
