//
//  kTextFiledPlaceHolder.swift
//  kPlaceholderTextFiled
//
//  Created by Kiran Patel on 7/8/16.
//  Copyright © 2016  SOTSYS175. All rights reserved.
//

import UIKit

enum placeholderDirection: String {
    case placeholderUp = "up"
    case placeholderDown = "down"
}

class TextFiledPlaceHolder: UITextField {
    var enableMaterialPlaceHolder : Bool = true
    var placeholderAttributes = NSDictionary()
    var lblPlaceHolder = UILabel()
    var defaultFont = UIFont()
    var difference: CGFloat = 25.0
    var directionMaterial = placeholderDirection.placeholderUp
    var isUnderLineAvailabe : Bool = true
    
    var underLine:UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Initialize ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Initialize ()
    }
   
    func Initialize(){
        self.clipsToBounds = false
        self.addTarget(self, action: #selector(TextFiledPlaceHolder.textFieldDidChange), for: .editingChanged)
        self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: true)
        if isUnderLineAvailabe {
            underLine = UIImageView()
            underLine.backgroundColor = UIColor.init(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0)

            underLine.frame = CGRect(x: 0, y: self.frame.size.height-1, width : self.frame.size.width, height : 1)
            
            underLine.clipsToBounds = true
            self.addSubview(underLine)
        }
        defaultFont = self.font!
    }
    
    @IBInspectable var placeHolderColor: UIColor? = UIColor.lightGray {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder! as String ,
                                                            attributes:[NSAttributedStringKey.foregroundColor: placeHolderColor!])
        }
    }
    
    override internal var placeholder:String?  {
        didSet {
            //  NSLog("placeholder = \(placeholder)")
        }
        willSet {
            let atts  = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)] as [AnyHashable : NSObject]
            self.attributedPlaceholder = NSAttributedString(string: newValue!, attributes:atts as! [NSAttributedStringKey : Any])
            self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: self.enableMaterialPlaceHolder)
        }
    }
    
    override internal var attributedText:NSAttributedString?  {
        didSet {
            //  NSLog("text = \(text)")
        }
        willSet {
            if (self.placeholder != nil) && (self.text != "")
            {
                let string = NSString(string : self.placeholder!)
                self.placeholderText(string)
            }
            
        }
    }
    
    @objc func textFieldDidChange(){
        if self.enableMaterialPlaceHolder {
            if (self.text == nil) || (self.text?.characters.count)! > 0 {
                self.lblPlaceHolder.alpha = 1
                self.attributedPlaceholder = nil
                self.lblPlaceHolder.textColor = self.placeHolderColor
                let fontSize = self.font!.pointSize;
                self.lblPlaceHolder.font = UIFont.init(name: (self.font?.fontName)!, size: fontSize-3)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {() -> Void in
                if (self.text == nil) || (self.text?.characters.count)! <= 0 {
                    self.lblPlaceHolder.font = self.defaultFont
                    self.underLine.backgroundColor = UIColor.init(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0)
                    self.lblPlaceHolder.textColor = self.placeHolderColor

                    self.lblPlaceHolder.frame = CGRect(x: self.lblPlaceHolder.frame.origin.x, y : 0, width :self.frame.size.width, height : self.frame.size.height)
                }
                else {
                    if self.directionMaterial == placeholderDirection.placeholderUp {
                        self.lblPlaceHolder.frame = CGRect(x : self.lblPlaceHolder.frame.origin.x, y : -self.difference, width : self.frame.size.width, height : self.frame.size.height)
                        
                        self.lblPlaceHolder.textColor = UIColor.init(red: 0/255, green: 208/255, blue: 244/255, alpha: 1)
                        
                        self.underLine.backgroundColor = UIColor.init(red: 0/255, green: 208/255, blue: 244/255, alpha: 1)

                    }else{
                        self.lblPlaceHolder.frame = CGRect(x : self.lblPlaceHolder.frame.origin.x, y : self.difference, width : self.frame.size.width, height : self.frame.size.height)
                    }
                    
                }
                }, completion: {(finished: Bool) -> Void in
            })
        }
    }
    
    func EnableMaterialPlaceHolder(enableMaterialPlaceHolder: Bool){
        self.enableMaterialPlaceHolder = enableMaterialPlaceHolder
        self.lblPlaceHolder = UILabel()
        self.lblPlaceHolder.frame = CGRect(x: 0, y : 0, width : 0, height :self.frame.size.height)
        self.lblPlaceHolder.font = UIFont.systemFont(ofSize: 10)
        self.lblPlaceHolder.alpha = 0
        self.lblPlaceHolder.clipsToBounds = true
        self.addSubview(self.lblPlaceHolder)
        self.lblPlaceHolder.attributedText = self.attributedPlaceholder
        //self.lblPlaceHolder.sizeToFit()
    }
    
    func placeholderText(_ placeholder: NSString){
        let atts  = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)] as [AnyHashable : NSObject]
        self.attributedPlaceholder = NSAttributedString(string: placeholder as String , attributes:atts as? [NSAttributedStringKey : Any])
        self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: self.enableMaterialPlaceHolder)
    }
    
    override func becomeFirstResponder()->(Bool){
        let returnValue = super.becomeFirstResponder()
        return returnValue
    }
    
    override func resignFirstResponder()->(Bool){
        let returnValue = super.resignFirstResponder()
        return returnValue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
