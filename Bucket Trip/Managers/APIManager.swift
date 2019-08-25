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

//

extension String{
    func isTrue() -> Bool {
        return self == "True"
    }
}

enum RequestActionType:String {
    case accept = "add"
    case reject = "cancel"
    case remove = "remove"
}
enum RequestAction:String {
    case accept = "accepted"
    case reject = "rejected"
}

struct API_K {
    static let DEVICE_TYPE = "Android"
    static let API_KEY = "base64:8WGdd0uX3GtRtTxeOyuHd3864Mqfc6C/cbhzpEZUdxA="
    static let BaseUrlStr:String = "http://buckettrip.brooklynbubblesny.com/"

    static let BaseURL = URL(string:"\(BaseUrlStr)apis/")!
    
    static let  LOGIN = "login"
    static let  REGISTER = "registration"
    static let  SUGGESTED_FRIENDS = "friends/suggestion"
    
    static let  GET_COUNTRIES = "getCountries"
    static let  CREATE_OTP = "createOtp"
    static let  GET_PASSWORD = "retrievePassword"
    static let  logout = "logout"

    static let  ADD_FRIEND = "addFriend"
    static let  GET_FRIEND = "getFriend"
    static let GET_WOULD_FRIEND = "getWouldBeFriend"
    static let ACCEPT_REJECT_FRIEND = "actionToFriendRequest"
    static let REMOVE_FRIEND = "removeFriend"
}

struct API_STRING {
    
    static let  PROPILE_REVIEW_ALERT = "Please set up your profile"
    
    static let  LOGIN_VALIDATION_TEXT = "The duplicate key value is"
    
    static let  NOTE_ADD_SUCCESS = "Note sent successfully"
    static let  COMMENT_ADD_SUCCESS = "Feedback sent successfully"
    static let  POST_ADD_SUCCESS = "Upload ad successful"
    static let  POST_ADD_FAIL = "Upload ad failed"

    static let  POST_EDIT_SUCCESS = "Post edited successfully"
    static let  POST_EDIT_FAIL = "Post edit failed"

    static let  NOTE_ADD_FAIL = "Note sending failed"
    static let  COMMENT_ADD_FAIL = "Feedback sending failed"
    
    static let  DELETE_ADD_SUCCESS = "Ad delete successful"
    static let  DELETE_ADD_FAIL = "Ad delete failed"
}

struct APP_STRING {
   
    static let  SERVER_ERROR = "Something went wrong! Please, try later"
    static let PROGRESS_TEXT = "Please wait..."
    static let CommentPlaceHolder = "Write your comment"
    static let PostPlaceHolder = "Details"
    static let CategoryPlaceHolder = "Category"
    static let notePlaceHolder = "Write your note"
    static let EmptyDataText = "No ads are available"
}

enum ResponseType {
    case success
    case fail
    case invalid
}

class APIManager: NSObject {
    
    /*
     *-------------------------------------------------------
     * MARK:- singletone initialization
     *-------------------------------------------------------
     */
    
    private struct Static {
        static var intance: APIManager? = nil
    }
    
    private static var __once: () = {
        Static.intance = APIManager()
    }()
    
    class var manager: APIManager {
        _ = APIManager.__once
        return Static.intance!
    }
    
    func login(userName:String, password:String, loginType:Int, withCompletionHandler completion:(( _ status: Bool,_ authToken:String?, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["userName":userName,
                                      "password":password,
                                      "loginType":"\(loginType)",
                                      "pushToken":"1234567890",
                                      "deviceType":"iphone",
                                      "latitude":"23.90",
                                      "longitude":"90.23",
                                      "email":"",
                                      "fullName":"",
                                      "avatar":"",
                                      "country":"",
                                      "phone":""]
 
        Request(.post, API_K.LOGIN, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue

                    if !isSuccess{
                        completion?(false,nil,msg)
                    }
                    else{
                        let token:String = json["authToken"].stringValue

                        completion?(true,token,msg)
                    }
                }
                else {
                    completion?(false,nil,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil,error.localizedDescription)
            }
        })
    }
   
    func logOut(completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.post, API_K.logout, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
                
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    
    func register(userName:String ,fullName:String, email:String,country:String,phone:String, password:String, withCompletionHandler completion:(( _ status: Bool,_ token:String?, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["userName":userName,
                                      "password":password,
                                      "pushToken":"1234567890",
                                      "deviceType":"iphone",
                                      "email":email,
                                      "latitude":"23.90",
                                      "longitude":"90.23",
                                      "fullName":fullName,
                                      "avatar":"",
                                      "country":country,
                                      "phone":phone]
        
        
        Request(.post, API_K.REGISTER, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue

                    if !isSuccess{
                        completion?(false,nil,msg)
                    }
                    else{
                        let token:String = json["authToken"].stringValue
                        completion?(true,token,msg)
                    }
                }
                else {
                    completion?(false,nil,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil,error.localizedDescription)
            }
        })
    }
    
    func getOtp(email:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["email":email]
        
        Request(.post, API_K.CREATE_OTP, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,error.localizedDescription)
            }
        })
    }
    
    func resetPassword(otp:String, password:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["otp":otp,
                                      "password":password,
                                      "passwordConfirmation":password]
        
        Request(.post, API_K.GET_PASSWORD, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,error.localizedDescription)
            }
        })
    }
    
    func getSuggestedFriends(completion:(( _ feeds: [UserModel])->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.post, API_K.SUGGESTED_FRIENDS, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if let locationsArray = json["data"]["lists"].arrayObject as? [Gloss.JSON] {
                    
                    if let histories = [UserModel].from(jsonArray: locationsArray) {
                        
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?([])
            }
        })
    }
    
    func getFriends(completion:(( _ friends: [UserModel])->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.post, API_K.GET_FRIEND, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                   // let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?([])
                    }
                    else{
                        if let locationsArray = json["data"].arrayObject as? [Gloss.JSON] {
                            
                            if let histories = [UserModel].from(jsonArray: locationsArray) {
                                
                                completion?(histories)
                                
                            } else {
                                
                                completion?([])
                            }
                        }
                    }
                }
                else {
                    completion?([])
                }
                
                if let locationsArray = json["data"]["lists"].arrayObject as? [Gloss.JSON] {
                    
                    if let histories = [UserModel].from(jsonArray: locationsArray) {
                        
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?([])
            }
        })
    }
    
    func getListWouldFriends(completion:(( _ friends: [UserModel])->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.post, API_K.GET_WOULD_FRIEND, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    // let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?([])
                    }
                    else{
                        if let locationsArray = json["data"].arrayObject as? [Gloss.JSON] {
                            
                            if let histories = [UserModel].from(jsonArray: locationsArray) {
                                
                                completion?(histories)
                                
                            } else {
                                
                                completion?([])
                            }
                        }
                    }
                }
                else {
                    completion?([])
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?([])
            }
        })
    }
    
    func getCountryList(completion:(( _ friends: [CountryModel])->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.post, API_K.GET_COUNTRIES, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    
                    if !isSuccess{
                        completion?([])
                    }
                    else{
                        if let locationsArray = json["data"]["lists"].arrayObject as? [Gloss.JSON] {
                            
                            if let histories = [CountryModel].from(jsonArray: locationsArray) {
                                
                                completion?(histories)
                                
                            } else {
                                
                                completion?([])
                            }
                        }
                    }
                }
                else {
                    completion?([])
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?([])
            }
        })
    }
    
    func inviteFriend(userId:String, withCompletionHandler completion:(( _ status: Bool, _ msg:String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["friendId":userId]
        
        Request(.post, API_K.ADD_FRIEND, parameters: params )?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    
    func performFriendRequestAction(userId:String,type:RequestActionType, withCompletionHandler completion:(( _ status: Bool, _ msg:String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
      
        let params:[String:String] = ["friendId":userId,
                                      "action":type.rawValue]
        
        Request(.post, type == .remove ? API_K.REMOVE_FRIEND : API_K.ACCEPT_REJECT_FRIEND, parameters: params )?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
}

struct API_K_TRIP {
    static let  GET_TRIP_LOCATION = "getLocations"
    static let  CREATE_TRIP = "createTrip"
    static let GET_TRIP_LIST = "getMyTrip"
    static let REMOVE_TRIP = "deleteTrip"
    static let EDIT_TRIP = "updateTrip"
    static let INVITED_TRIP_LIST = "getInvitedTrip"
    static let GET_TRIP_DETAILS = "getTripDetails"
}
// Trip Module
extension APIManager{
    // Create Trip
    
    func createTrip(tripTitle:String,tripDescription:String,selFriend:[UserModel],location:SearchPlaceModel?,locationDetails:SearchPlaceDetailModel?,fromDate:String?,toDate:String?, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        var ids:[String] = []
        for frnd:UserModel in selFriend {
            if let uid = frnd.user_id{
                ids.append("\(uid)")
            }
        }
        let idStr = ids.joined(separator:",")
        let lat = "\(locationDetails?.geometry?.location?.lat ?? 0)"
        let lng = "\(locationDetails?.geometry?.location?.lng ?? 0)"
        let  imgStr = "https://maps.googleapis.com/maps/api/staticmap?center=\(lat),\(lng)&zoom=12&size=600x400"

        let params:[String:Any] = ["locationName":location?.strFormat?.displayName() ?? "Canada",
                                   "locationImage":imgStr,
                                   "latitude":lat,
                                   "longitude":lng,
                                   "tripTitle":tripTitle,
                                   "startDate":fromDate ?? "",
                                   "endDate":toDate ?? "",
                                   "friendList":idStr,
                                   "description":tripDescription]
        submit(param: params, method: API_K_TRIP.CREATE_TRIP) { (sts, msg) in
            completion?(sts,msg)
        }
    }
    
    //Remove Trip
    func removeTrip(tripId:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        submit(param: ["tripId":tripId], method: API_K_TRIP.REMOVE_TRIP) { (sts, msg) in
            completion?(sts,msg)
        }
    }
    
    //Edit trip
    
    func updateTrip(tripId:String,tripTitle:String,tripDescription:String,selFriend:[UserModel],location:SearchPlaceModel?,locationDetails:SearchPlaceDetailModel?,fromDate:String?,toDate:String?,locationImage:String?, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        var ids:[String] = []
        for frnd:UserModel in selFriend {
            if let uid = frnd.user_id{
                ids.append("\(uid)")
            }
        }
        let idStr = ids.joined(separator:",")
        
        let params:[String:Any] = ["tripId":tripId,
                                   "locationName":location?.strFormat?.displayName() ?? "Canada",
                                   "locationImage":locationImage ?? "",
                                   "latitude":"\(locationDetails?.geometry?.location?.lat ?? 0)",
            "longitude":"\(locationDetails?.geometry?.location?.lng ?? 0)",
            "tripTitle":tripTitle,
            "startDate":fromDate ?? "",
            "endDate":toDate ?? "",
            "friendList":idStr,
            "description":tripDescription]
        submit(param: params, method: API_K_TRIP.CREATE_TRIP) { (sts, msg) in
            completion?(sts,msg)
        }
    }
    
   
    
    //Get trip list
    func getTripList(completion:(( _ trips: [TripModel])->Void)?) {
        
        getList(method: API_K_TRIP.GET_TRIP_LIST) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [TripModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    
    //Invited Trip list
    func getInvitedTripList(completion:(( _ trips: [TripModel])->Void)?) {
        
        getList(method: API_K_TRIP.INVITED_TRIP_LIST) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [TripModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    
    //Get Locations
    func getTripLocationList(completion:(( _ trips: [LocationModel])->Void)?) {
        
        getDataList(method: API_K_TRIP.GET_TRIP_LOCATION) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [LocationModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    
    func getTripDetails(tripId:String, withCompletionHandler completion:(( _ frnds: [TripModel])->Void)?) {
       
        let params:[String:Any] = ["tripId":tripId]
        getList(params, method: API_K_TRIP.GET_TRIP_DETAILS) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [TripModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
      
    }

    func getDataList(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:(( _ status: Bool, _ data: [Gloss.JSON]?)->Void)?) {
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)

        Request(.post, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    
                    if !isSuccess{
                        completion?(false,nil)
                    }
                    else{
                        if let locationsArray = json["data"]["lists"].arrayObject as? [Gloss.JSON] {
                            completion?(true,locationsArray)
                        }
                        else{
                            completion?(false,nil)
                        }
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    
    func getDataModel(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:(( _ status: Bool, _ data: Gloss.JSON?,_ msg:String?)->Void)?) {
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.post, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue

                    if !isSuccess{
                        completion?(false,nil,msg)
                    }
                    else{
                        if let locationsArray = json["data"].dictionaryObject {
                            completion?(true,locationsArray,msg)
                        }
                        else{
                            completion?(false,nil,msg)
                        }
                    }
                }
                else {
                    completion?(false,nil,APP_STRING.SERVER_ERROR)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil,error.localizedDescription)
            }
        })
    }
    
    func getList(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:(( _ status: Bool, _ data: [Gloss.JSON]?)->Void)?) {
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.post, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    
                    if !isSuccess{
                        completion?(false,nil)
                    }
                    else{
                        if let locationsArray = json["data"].arrayObject as? [Gloss.JSON] {
                            completion?(true,locationsArray)
                        }
                        else{
                            completion?(false,nil)
                        }
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    
    func submit(param:[String:Any],method:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.post, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,error.localizedDescription)
            }
        })
    }
}

struct API_K_TASK {
    static let  CREATE_TASK = "createTask"
    static let  GET_ALL_TRIP_TASK = "getProposedAllTripTask"
    static let GET_TRIP_TASK = "getProposedAllTripTask"
    static let ACCEPT_REJECT_TASK = "acceptRejectTask"
    static let GET_ACCEPTED_TASK = "acceptedTaskList"
    static let GET_TASK_DETAILS = "getProposedTask"
    static let UPLOAD_TASK_FEEDBACK_IMAGE = "uploadFeedbackImage"
    static let UPLOAD_TASK_FEEDBACK_VIDEO = "uploadFeedbackVideo"
    static let ADD_FEEDBACK = "addFeedback"
}
// task module
extension APIManager {
    //Create Task
    func createTask(tripId:String,tasks:[String],visibility:Status, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
      
        
        let params:[String:Any] = ["tripId":tripId,
                                   "tasks":tasks,
                                   "private":visibility == .showAll ? "public":"private"]
        submit(param: params, method: API_K_TASK.CREATE_TASK) { (sts, msg) in
            completion?(sts,msg)
        }
    }
    
    //Get pending tasks
    func getPendingTasks(completion:(( _ trips: [TripModel])->Void)?) {
        
        getList(method: API_K_TASK.GET_ALL_TRIP_TASK) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [TripModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    
    
    //Get task Details
    func getTaskDetails(tripId:String, withCompletionHandler completion:(( _ trips: [TripModel])->Void)?) {
        
        let params:[String:Any] = ["tripId":tripId]
        getList(params,method: API_K_TASK.GET_TASK_DETAILS) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [TripModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    
    func acceptRejectTask(tripId:String,friendId:String,type:RequestAction, withCompletionHandler completion:(( _ status: Bool, _ msg:String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["tripId":tripId,
                                      "action":type.rawValue,
                                      "friendId":friendId]
        
        Request(.post, API_K_TASK.ACCEPT_REJECT_TASK, parameters: params )?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    
    //Get pending tasks
    func getAcceptedTasks(completion:(( _ trips: [TripModel])->Void)?) {
        
        getList(method: API_K_TASK.GET_ACCEPTED_TASK) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [TripModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    func uploadTaskPhoto(_ image:UIImage?,taskId:String, withCompletionHandler completion:(( _ status:Bool, _ msg:String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["taskId":taskId]
        
        UploadRequest(
            .post,API_K_TASK.UPLOAD_TASK_FEEDBACK_IMAGE,
            multipartFormData: { multipartFormData in
                // multipartFormData.appendBodyPart(fileURL: fileURL!, name: "unicorn")
                if let image = image, let imageData =  UIImageJPEGRepresentation(image, 0.8) {
                    multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "application/octet-stream")
                }
                
                for (key, value) in params {
                    let val:String = value
                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
                }
        },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ (response) -> Void in
                        switch response.result{
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                            
                            if let jsonDic = json.dictionaryObject {
                                let status:Bool = jsonDic["success"] as! Bool
                                let mssg = jsonDic["message"] as! String
                                let imagedict:[String:String] = jsonDic["data"] as! [String : String]
                                completion?(status,mssg)
/*
                               if let imageName =  imagedict["imageName"] {
                                completion?(status,mssg,imageName)
                                }
                               else{
                                completion?(status,mssg,nil)
                                }*/
                            }
                            else {
                                completion?(false,APP_STRING.SERVER_ERROR)
                            }
                            SVProgressHUD.dismiss()
                            
                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            completion?(false,APP_STRING.SERVER_ERROR)
                        }
                    }
                case .failure(let encodingError):
                    SVProgressHUD.dismiss()
                    completion?(false,APP_STRING.SERVER_ERROR)
                }
        })
    }
    
    func uploadTaskVideo(_ videoURL:URL?,taskId:String, withCompletionHandler completion:(( _ status:Bool, _ msg:String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["taskId":taskId]
        
        UploadRequest(
            .post,API_K_TASK.UPLOAD_TASK_FEEDBACK_VIDEO,
            multipartFormData: { multipartFormData in
                // multipartFormData.appendBodyPart(fileURL: fileURL!, name: "unicorn")
                 multipartFormData.append(videoURL!, withName: "video", fileName: "video.mp4", mimeType: "video/mp4")
                
                for (key, value) in params {
                    let val:String = value
                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
                }
        },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ (response) -> Void in
                        switch response.result{
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                            
                            if let jsonDic = json.dictionaryObject {
                                let status:Bool = jsonDic["success"] as! Bool
                                let mssg = jsonDic["message"] as! String
                                let videodict:[String:String] = jsonDic["data"] as! [String : String]
                                
                                NSLog("jsonDIC in uploadfeedbackVideo %@", jsonDic)
                                
                                completion?(status,mssg)
                                /*
                                 if let imageName =  imagedict["imageName"] {
                                 completion?(status,mssg,imageName)
                                 }
                                 else{
                                 completion?(status,mssg,nil)
                                 }*/
                            }
                            else {
                                completion?(false,APP_STRING.SERVER_ERROR)
                            }
                            SVProgressHUD.dismiss()
                            
                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            completion?(false,APP_STRING.SERVER_ERROR)
                        }
                    }
                case .failure(let encodingError):
                    SVProgressHUD.dismiss()
                    completion?(false,APP_STRING.SERVER_ERROR)
                }
        })
    }

    
    func updateFeedback(taskId:String,imageUrl:String,videoUrl:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        let params:[String:Any] = ["taskId":taskId,"imageUrl":imageUrl,"videoUrl":videoUrl]
        
        
        submit(param: params, method: API_K_TASK.ADD_FEEDBACK) { (sts, msg) in
            completion?(sts,msg)
        }
    }
}

struct API_K_PROFILE {
    static let MY_PROFILE = "myProfile"
    static let OTHER_PROFILE = "othersProfile"
    static let UPLOAD_PROFILE_PICTURE = "uploadProfilePicture"
    static let UPLOAD_COVER_PHOTO = "uploadCoverPhoto"
    static let UPDATE_PROFILE = "updateProfile"
}
extension APIManager{
    
    func getMyProfile(completion:(( _ status: Bool,_ user:UserModel?, _ message: String?)->Void)?) {
        
        getDataModel(method: API_K_PROFILE.MY_PROFILE) { (sts, dataModel,msg) in
            if sts{
                if let jsA = dataModel{
                    if let histories = UserModel.init(json: jsA) {
                        completion?(true,histories,msg)
                        
                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }

    func getOtherProfile(_ userId:String, withCompletionHandler completion:(( _ status: Bool,_ user:UserModel?, _ message: String?)->Void)?) {
        let param:[String:Any] = ["seekedUserId":userId]
        getDataModel(param, method: API_K_PROFILE.OTHER_PROFILE) { (sts, dataModel,msg) in
            if sts{
                if let jsA = dataModel{
                    if let histories = UserModel.init(json: jsA) {
                        completion?(true,histories,msg)
                        
                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }
    func updateProfile(fullName:String,country:String,phone:String, aboutme:String, withCompletionHandler completion:(( _ status: Bool,_ token:String?, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["fullName":fullName,
                                      "country":country,
                                      "phone":phone,
                                      "aboutMe":aboutme]
        
        Request(.post, API_K_PROFILE.UPDATE_PROFILE, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,nil,msg)
                    }
                    else{
                        let token:String = json["authToken"].stringValue
                        completion?(true,token,msg)
                    }
                }
                else {
                    completion?(false,nil,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil,error.localizedDescription)
            }
        })
    }
    
    func upload(_ image:UIImage?,type:PictureSelectType, withCompletionHandler completion:(( _ status:Bool, _ msg:String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = [:]
        
        UploadRequest(
            .post,
            (type == .profilepicture) ? API_K_PROFILE.UPLOAD_PROFILE_PICTURE:API_K_PROFILE.UPLOAD_COVER_PHOTO,
            multipartFormData: { multipartFormData in
                // multipartFormData.appendBodyPart(fileURL: fileURL!, name: "unicorn")
                if let image = image, let imageData =  UIImageJPEGRepresentation(image, 0.8) {
                    multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "application/octet-stream")
                }
                
                for (key, value) in params {
                    let val:String = value
                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
                }
        },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ (response) -> Void in
                        switch response.result{
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                         
                            if let jsonDic = json.dictionaryObject {
                                let status:Bool = jsonDic["success"] as! Bool
                                let mssg = jsonDic["message"] as! String
                                completion?(status,mssg)
                            }
                            else {
                                completion?(false,APP_STRING.SERVER_ERROR)
                            }
                            SVProgressHUD.dismiss()

                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            completion?(false,APP_STRING.SERVER_ERROR)
                        }
                    }
                case .failure(let encodingError):
                    SVProgressHUD.dismiss()
                    completion?(false,APP_STRING.SERVER_ERROR)
                    
                }
        })
        
    }
}

struct API_K_PASSPORT {
    static let  GET_MY_PASSPORTS = "getPassports"
    static let  GET_TRIP_PASSPORT = "getPassportforTrip"
    static let GET_PASSPORT_DETAILS = "getPassportDetails"
    static let CONFIRM_PASSPORT = "confirmPassport"
}
// task module
extension APIManager {
    //Get Passport
    func getMyPassports(completion:(( _ trips: [TripModel])->Void)?) {
        
        getList(method: API_K_PASSPORT.GET_MY_PASSPORTS) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [TripModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    
    
    //Get task Details
    func getPassportDetails(tripId:String,friendId:String, withCompletionHandler completion:(( _ trips: [TripModel])->Void)?) {
        
        let params:[String:Any] = ["tripId":tripId,
                                   "friendId":friendId]
        getList(params,method: API_K_PASSPORT.GET_PASSPORT_DETAILS) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [TripModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    
    func confirmPassport(tripId:String,friendId:String, withCompletionHandler completion:(( _ status: Bool, _ msg:String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["tripId":tripId,
                                      "friendId":friendId]
        
        Request(.post, API_K_PASSPORT.CONFIRM_PASSPORT, parameters: params )?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
}

struct API_K_BLOG {
    static let GET_BLOG_LIST = "getBlogs"
    static let CREATE_BLOG = "createBlog"
    static let UPLOAD_BLOG_IMAGE = "uploadBlockImage"
    static let GET_BLOG_DETAILS = "othersProfile"
    static let UPLOAD_BLOG_VIDEO = "uploadBlogVideo"

}

extension APIManager{
    
    func uploadBlogImage(_ image:UIImage?, withCompletionHandler completion:(( _ status:Bool,_ url:String?, _ msg:String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        UploadRequest(
            .post,API_K_BLOG.UPLOAD_BLOG_IMAGE,
            multipartFormData: { multipartFormData in
                if let image = image, let imageData =  UIImageJPEGRepresentation(image, 0.8) {
                    multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "application/octet-stream")
                }
                
                /*for (key, value) in params {
                    let val:String = value
                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
                }*/
        },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ (response) -> Void in
                        switch response.result{
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                            
                            if let jsonDic = json.dictionaryObject {
                                let status:Bool = jsonDic["success"] as! Bool
                                let mssg = jsonDic["message"] as! String
                                let imagedict:[String:String] = jsonDic["data"] as! [String : String]
                                
                                 if let imageName =  imagedict["imageName"] {
                                 completion?(status,imageName,mssg)
                                 }
                                 else{
                                 completion?(status,nil,mssg)
                                 }
                            }
                            else {
                                completion?(false,nil,APP_STRING.SERVER_ERROR)
                            }
                            SVProgressHUD.dismiss()
                            
                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            completion?(false,nil,APP_STRING.SERVER_ERROR)
                        }
                    }
                case .failure(let encodingError):
                    SVProgressHUD.dismiss()
                    completion?(false,nil,APP_STRING.SERVER_ERROR)
                }
        })
    }
    
    func uploadBlogVideo(_ videoURL:URL?, withCompletionHandler completion:(( _ status:Bool,_ url:String?,_ thumburl:String?, _ msg:String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
//        var movieData: NSData?
//        do {
//            movieData = try NSData(contentsOfFile: (videoURL?.relativePath)!, options: NSData.ReadingOptions.alwaysMapped)
//        } catch _ {
//            movieData = nil
//            return
//        }
        
        UploadRequest(
            .post,API_K_BLOG.UPLOAD_BLOG_VIDEO,
            multipartFormData: { multipartFormData in
                
                //  upload only mp4 video
                multipartFormData.append(videoURL!, withName: "video", fileName: "video.mp4", mimeType: "video/mp4")
                //  upload any type of video
                //multipartFormData.append(videoURL!, withName: "File1")
//                multipartFormData.append(("VIDEO".data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "Type")
//
                
        
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ (response) -> Void in
                        switch response.result{
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                            
                            if let jsonDic = json.dictionaryObject {
                                let status:Bool = jsonDic["success"] as! Bool
                                let mssg = jsonDic["message"] as! String
                                let videodict:[String:String] = jsonDic["data"] as! [String : String]

                                NSLog("jsonDIC in uploadBlogVideo %@", jsonDic)
                                
                                if let videoUrl =  videodict["videoPath"] {
                                    if let thumbUrl = videodict["videoThumbPath"]{
                                        
                                        completion?(status,videoUrl,thumbUrl,mssg)
                                    }
                                }
                                else{
                                    completion?(status,nil,nil,mssg)
                                }
                            }
                            else {
                                completion?(false,nil,nil,APP_STRING.SERVER_ERROR)
                            }
                            SVProgressHUD.dismiss()
                            
                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            completion?(false,nil,nil,APP_STRING.SERVER_ERROR)
                        }
                    }
                case .failure(let encodingError):
                    SVProgressHUD.dismiss()
                    completion?(false,nil,nil,APP_STRING.SERVER_ERROR)
                }
        })
    }
    
    func createBlog(title:String,details:String,imageUrl:String?,videoUrl:String?, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        var params:[String:String] = ["blogTitle":title,
                                      "description":details]
        if let imgUrl = imageUrl{
            params["imageUrl"] = imgUrl
        }
        if let videoUrl = videoUrl{
            params["videoUrl"] = videoUrl
        }

        submit(param: params, method: API_K_BLOG.CREATE_BLOG) { (sts, msg) in
            completion?(sts,msg)
        }
    }
    
    func getBlogPosts(type:BlogType, withCompletionHandler completion:(( _ trips: [BlogModel])->Void)?) {
        
        let params:[String:String] = ["getMyBlog":type.rawValue]
        
        getList(params,method: API_K_BLOG.GET_BLOG_LIST) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [BlogModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    
    func getBlogDetails(blogId:String, withCompletionHandler completion:(( _ trips: [TripModel])->Void)?) {
        
        let params:[String:Any] = ["blogId":blogId]
        getList(params,method: API_K_BLOG.GET_BLOG_DETAILS) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [TripModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
}



struct API_K_TRAVEL_HISTORY {
    static let GET_TRAVEL_HISTORY = "getTravelHistory"
    static let GET_MY_TRAVEL_HISTORY = "getMyTravelHistory"
    
}

extension APIManager{
    
    func getTravelHistories(completion:(( _ trips: [BlogHistoryModel])->Void)?) {
        
       // let params:[String:String] = ["getMyBlog":type.rawValue]
        
        getList(method: API_K_TRAVEL_HISTORY.GET_TRAVEL_HISTORY) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [BlogHistoryModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    
    func getTravelMyHistories(completion:(( _ trips: [BlogHistoryModel])->Void)?) {
        
        // let params:[String:String] = ["getMyBlog":type.rawValue]
        
        getList(method: API_K_TRAVEL_HISTORY.GET_MY_TRAVEL_HISTORY) { (sts, jsonArray) in
            if sts{
                if let jsA = jsonArray{
                    if let histories = [BlogHistoryModel].from(jsonArray: jsA) {
                        completion?(histories)
                        
                    } else {
                        
                        completion?([])
                    }
                }
                else{
                    completion?([])
                }
            }
            else{
                completion?([])
            }
        }
    }
    
}
