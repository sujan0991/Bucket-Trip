//
//  APIManager
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Gloss
import SVProgressHUD
import CoreLocation


struct GMS_K {
    
    static let  API_KEY = "AIzaSyALq1Ik9HGyb81DuDa18t1QLBgmrckA7Gs"
    static let BaseURL = URL(string: "https://maps.googleapis.com/maps/api/")!
  
    static let DIRECTION = "directions/json"
    static let PLACES = "place/autocomplete/json"
    static let PLACE_DETAIL = "place/details/json"
    static let PLACE_PHOTO = "place/photo"
    static let GEO_DETAIL = "geocode/json"
}

struct GMS_STRING {
    static let  SERVER_ERROR = "Something went wrong or server down!"

}
class GMSAPIManager: NSObject {
    
    
    /*
     *-------------------------------------------------------
     * MARK:- singletone initialization
     *-------------------------------------------------------
     */
    
    private struct Static {
        static var intance: GMSAPIManager? = nil
    }
    
    private static var __once: () = {
        Static.intance = GMSAPIManager()
    }()
    
    class var manager: GMSAPIManager {
        
        _ = GMSAPIManager.__once
        return Static.intance!
    }
   
    func getPlaces(searchString:String/*,currentLat:Double,currentLng:Double*/, withCompletionHandler completion:((_ status:Bool, _ place:[SearchPlaceModel], _ msg:String?)->Void)?) {
        
        let params:[String:Any] = [
            "input": (searchString as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!,
            //"location":"\(currentLat),\(currentLng)",

            "key":GMS_K.API_KEY,
            //"language": "en",
           // "radius": "500",
           // "components": "country:pt_BR"
            //"components": "country:BR"
        ]
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        GMSRequest(.get, GMS_K.PLACES, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if json["status"].stringValue == "OK"{
                    if let predictions = json["predictions"].arrayObject as? [Gloss.JSON] {
                        
                        if let places = [SearchPlaceModel].from(jsonArray: predictions) {
                            
                            completion?(true,places,nil)
                            
                        } else {
                            
                            completion?(false,[],GMS_STRING.SERVER_ERROR)
                        }
                    } else {
                        // SVProgressHUD.showError(withStatus: API_STRING.SERVER_ERROR)
                        completion?(false,[],GMS_STRING.SERVER_ERROR)
                    }
                }
                else if json["status"].stringValue != "success" {
                    if let erroMsg = json["message"].string {
                        completion?(false,[],erroMsg)
                    }
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                
                completion?(false,[],error.localizedDescription)
            }
        }).responseString(completionHandler: { (dtra) in
            print(dtra)
        })
    }
    
    func getGeoLoc(address:String, withCompletionHandler completion:((_ status:Bool, _ direction:PlaceModel?,_ msg:String?)->Void)?) {
        
        let params:[String:Any] = ["address": address]
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        GMSRequest(.get, GMS_K.GEO_DETAIL, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if json["status"].stringValue == "OK"{
                    
                    if let jsonDic = json["results"][0]["geometry"]["location"].dictionaryObject {
                        let model = PlaceModel(json: jsonDic)
                        if let model = model {
                            completion?(true,model, nil)
                        }
                    }
                }
                else if json["status"].stringValue != "FAILED" {
                    if let erroMsg = json["message"].string {
                        completion?(false,nil, erroMsg)
                    }
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                
                completion?(false,nil,error.localizedDescription)
            }
        }).responseString(completionHandler: { (dtra) in
            print(dtra)
        })
    }
    
    func getPlaceDetail(place:SearchPlaceModel, withCompletionHandler completion:((_ status:Bool, _ direction:SearchPlaceDetailModel?, _ msg:String?)->Void)?) {
        
        let params:[String:Any] = [
        "placeid": place.placeId ?? "",
        "key": GMS_K.API_KEY
        ]
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        GMSRequest(.get, GMS_K.PLACE_DETAIL, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if json["status"].stringValue == "OK"{
                    
                    if let jsonDic = json["result"].dictionaryObject {
                        let model = SearchPlaceDetailModel(json: jsonDic)
                        if let model = model {
                            completion?(true,model, nil)
                        }
                    }
                }
                else if json["status"].stringValue != "FAILED" {
                    if let erroMsg = json["message"].string {
                        completion?(false,nil, erroMsg)
                    }
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                
                completion?(false,nil,error.localizedDescription)
            }
        }).responseString(completionHandler: { (dtra) in
            print(dtra)
        })
    }
    
    func getPlacePhoto(place:SearchPlaceModel, withCompletionHandler completion:((_ status:Bool, _ direction:SearchPlaceDetailModel?, _ msg:String?)->Void)?) {
        
        
        let params:[String:Any] = [
            "key": GMS_K.API_KEY,
            "maxwidth":"320",
            "photoreference":place.reference!,
        ]
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        GMSRequest(.get, GMS_K.PLACE_PHOTO, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if json["status"].stringValue == "OK"{
                    
                    if let jsonDic = json["result"].dictionaryObject {
                        let model = SearchPlaceDetailModel(json: jsonDic)
                        if let model = model {
                            completion?(true,model, nil)
                        }
                    }
                }
                else if json["status"].stringValue != "FAILED" {
                    if let erroMsg = json["message"].string {
                        completion?(false,nil, erroMsg)
                    }
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                
                completion?(false,nil,error.localizedDescription)
            }
        }).responseString(completionHandler: { (dtra) in
            print(dtra)
        })
    }
}



