//
//  Extension.swift
//  Emisorasunidas
//
//  Created by Dulal Hossain on 8/14/17.
//  Copyright © 2017 DL. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) años"   }
        if months(from: date)  > 0 { return "\(months(from: date)) meses"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) semanas"   }
        if days(from: date)    > 0 { return "\(days(from: date)) días"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) horas"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) minutos" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) segundos" }
        return ""
    }
    func toDateString(format:String) -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
       // dateFormatter.dateStyle = .medium
        
        //Parse into NSDate
        let dateFromString : String = dateFormatter.string(from: self)
        //Return Parsed Date
        return dateFromString
    }
    
    func formattedTime() -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
       // dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.dateFormat = "MM/dd/YYYY"

        
        // dateFormatter.dateStyle = .MediumStyle
        
        //Parse into NSDate
        let dateFromString : String = dateFormatter.string(from:self)
        
        //Return Parsed Date
        return dateFromString
    }
    
}


extension UIImage{
    func getImageStr() -> String {
        let imageData:Data = UIImageJPEGRepresentation(self, 0.9)!
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        print(strBase64)
        return strBase64
    }
}


extension Data{
    func base64encode() -> String {
        let data = self.base64EncodedData(options: NSData.Base64EncodingOptions(rawValue: 0))
        let string = String(data: data, encoding: .utf8)!
        return string
            .replacingOccurrences(of: "+", with: "-", options: NSString.CompareOptions(rawValue: 0), range: nil)
            .replacingOccurrences(of: "/", with: "_", options: NSString.CompareOptions(rawValue: 0), range: nil)
            .replacingOccurrences(of: "=", with: "", options: NSString.CompareOptions(rawValue: 0), range: nil)
    }
}

extension String {
    func color () -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func base64decode() -> Data? {
        let rem = self.characters.count % 4
        
        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(repeating: "=", count: amount)
        }
        
        let base64 = self.replacingOccurrences(of: "-", with: "+", options: NSString.CompareOptions(rawValue: 0), range: nil)
            .replacingOccurrences(of: "_", with: "/", options: NSString.CompareOptions(rawValue: 0), range: nil) + ending
        
        return Data(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))
    }
    func getImage() -> UIImage {
        
        if let dataDecoded : Data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            if let decodedimage = UIImage(data: dataDecoded){
                return decodedimage
            }
        }
        
        return UIImage()
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func toDateTime() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        return dateFromString
    }
    
    func formattedDateTime(format:String) -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        return dateFromString
    }
    
    func toProtuguesDayOfWeek(format: String) -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        let df = DateFormatter()
        //df.dateFormat = format
        df.dateFormat = "EEEE"
        df.locale = Locale(identifier: "pt")
        
        let strDate = df.string(from: dateFromString)
        return strDate
    }
    func toProtuguesDate(format: String) -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        let df = DateFormatter()
        df.dateFormat = "EEEE: MMM dd, yyyy"
       // df.dateStyle = dateStyle
        df.locale = Locale(identifier: "pt")
        
        let strDate = df.string(from: dateFromString)
        return strDate
    }
    
    func toDate(format: String) -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        return dateFromString
    }
    func toDateString(format: String) -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        // df.dateStyle = dateStyle
        
        let strDate = df.string(from: dateFromString)
        return strDate
    }
    func asURL()->URL? {
        if let url = URL(string: self) {
            return url
        }
        return nil
    }
    
    func asImageResource()->Resource? {
        let str = self
        if let url = URL(string: str) {
            return url
        }
        return nil
    }
    
    func asResource()->Resource? {
        return asURL()
    }
}

extension UIButton{
    func call(_ phone: String) {
        let url:URL = URL(string: "tel://\(phone)")!
        if UIApplication.shared.canOpenURL(url){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
                // Fallback on earlier versions
            }
        }
    }
}
/*
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
*/
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


