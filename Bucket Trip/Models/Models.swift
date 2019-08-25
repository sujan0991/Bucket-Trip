//
//  InvoiceModel.swift
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Gloss
import SwiftyJSON
import MapKit

class Menu: Glossy {
    
    var menu_id: Int = 0
    var title: String?
    var icon: String?
    var icon_width: Int?
    var icon_height: Int?
    
    required init?(json: Gloss.JSON) {
        menu_id = ("id" <~~ json) ?? 0
        title = "title" <~~ json
        icon = "icon" <~~ json
        icon_width = "icon_width" <~~ json
        icon_height = "icon_height" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> menu_id,
            "title" ~~> title,
            "icon" ~~> icon,
            "icon_height" ~~> icon_height,
            "icon_width" ~~> icon_width])
    }
}


class CountryModel: Glossy {
    
    var country_id: String?
    var iso: String?
    var name: String?
    var niceName: String?
    var iso3: String?
    var numCode: String?
    var phoneCode: String?
    var status: String?
    var deleted_at: String?
    var created_at: String?
    var updated_at: String?
    

    required init?(json: Gloss.JSON) {
        country_id = "id" <~~ json
        iso = "iso" <~~ json
        name = "name" <~~ json
        niceName = "nicename" <~~ json
        iso3 = "iso3" <~~ json
        numCode = "numcode" <~~ json
        phoneCode = "phonecode" <~~ json
        status = "status" <~~ json
        deleted_at = "deleted_at" <~~ json
        created_at = "created_at" <~~ json
        updated_at = "updated_at" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> country_id,
            "iso" ~~> iso,
            "iso3" ~~> iso3,
            "name" ~~> name,
            "nicename" ~~> niceName,
            "numcode" ~~> numCode,
            "phonecode" ~~> phoneCode,
            "status" ~~> status,
            "deleted_at" ~~> deleted_at,
            "created_at" ~~> created_at,
            "updated_at" ~~> updated_at
            ])
    }
}


class LocationModel: Glossy {
    
    var location_id: String?
    var country_id: String?
    var location_name: String?
    var iso: String?
    var iso3: String?
    var name: String?
    var nicename: String?
    var image: String?
    var deleted_at: String?
    var created_at: String?
    var updated_at: String?
    
    
    required init?(json: Gloss.JSON) {
        location_id = "id" <~~ json
        country_id = "country_id" <~~ json
        location_name = "location_name" <~~ json
        iso = "iso" <~~ json
        iso3 = "iso3" <~~ json
        name = "name" <~~ json
        image = "image" <~~ json
        nicename = "nicename" <~~ json
        deleted_at = "deleted_at" <~~ json
        created_at = "created_at" <~~ json
        updated_at = "updated_at" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> location_id,
            "country_id" ~~> country_id,
            "iso" ~~> iso,
            "iso3" ~~> iso3,
            "name" ~~> name,
            "image" ~~> image,
            "nicename" ~~> nicename,
            "location_name" ~~> location_name,
            "deleted_at" ~~> deleted_at,
            "created_at" ~~> created_at,
            "updated_at" ~~> updated_at
            ])
    }
}
class UserModel: Glossy {

    var user_id: Int?
    var user_name: String?
    var full_name: String?
    var country: String?
    var phone: String?
    var email: String?

    var login_type: Int?
    var socialId: String?
    var avatar: String?
    var latitude: String?
    var longitude: String?
    
    var about_me: String?
    var cover_photo: String?

    
    required init?(json: Gloss.JSON) {
        user_id = "id" <~~ json
        user_name = "user_name" <~~ json
        full_name = "full_name" <~~ json
        country = "country" <~~ json
        about_me = "about_me" <~~ json
        phone = "phone" <~~ json
        email = "email" <~~ json
        login_type = "login_type" <~~ json
        socialId = "socialId" <~~ json
        avatar = "avatar" <~~ json
        latitude = "latitude" <~~ json
        longitude = "longitude" <~~ json
        cover_photo = "cover_photo" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> user_id,
            "user_name" ~~> user_name,
            "full_name" ~~> full_name,
            "country" ~~> country,
            "phone" ~~> phone,
            "email" ~~> email,
            "login_type" ~~> login_type,
            "socialId" ~~> socialId,
            "avatar" ~~> avatar,
            "latitude" ~~> latitude,
            "longitude" ~~> longitude,
            "cover_photo" ~~> cover_photo,
            "about_me" ~~> about_me
            ])
    }
}


class TaskModel: Glossy {
    
    var created_at: String?
    var updated_at: String?
    var task_id: String?
    var task_description: String?
    
    var feedBack: [FeedBackModel] = []


    required init?(json: Gloss.JSON) {
        created_at = "created_at" <~~ json
        updated_at = "updated_at" <~~ json
        task_id = "id" <~~ json
        feedBack = ("feedBack" <~~ json) ?? []

        task_description = "task_description" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> task_id,
            "created_at" ~~> created_at,
            "updated_at" ~~> updated_at,
            "task_description" ~~> task_description,
            "feedBack" ~~> feedBack
            ])
    }
}
class TripModel: Glossy {
    
    var trip_id: String?
    var ID: String?
    var country_id: String?
    var user_id: String?
    var user_name: String?
    var avatar: String?

    var image: String?
    var tripDetails: String?

    var location_id: String?
    var completed: Bool = false
    var location_name: String?
    var iso: String?
    var iso3: String?
    var name: String?
    var nicename: String?

    var start_date: String?
    var end_date: String?

    var deleted_at: String?
    var created_at: String?
    var updated_at: String?
    var full_name: String?
    var location_image: String?
    
    var trip_latitude: String?
    var trip_longitude: String?
    var trip_title: String?
    var trip_description: String?
    
    var invitedFriends:[UserModel] = []
    var tasks:[TaskModel] = []
    var friend_name: String?
    var friend_country: String?
    var friend_id: String?

    

    required init?(json: Gloss.JSON) {
        trip_id = "trip_id" <~~ json
        ID = "id" <~~ json
        country_id = "country_id" <~~ json
        user_id = "user_id" <~~ json
        user_name = "user_name" <~~ json
        image = "image" <~~ json
        tripDetails = "description" <~~ json
        location_id = "location_id" <~~ json
        avatar = "avatar" <~~ json
        completed = "completed" <~~ json ?? false
        
        location_name = "location_name" <~~ json
        iso = "iso" <~~ json
        iso3 = "iso3" <~~ json
        name = "name" <~~ json
        nicename = "nicename" <~~ json
        start_date = "start_date" <~~ json
        end_date = "end_date" <~~ json
        created_at = "created_at" <~~ json
        deleted_at = "deleted_at" <~~ json
        updated_at = "updated_at" <~~ json
        full_name = "full_name" <~~ json
        location_image = "location_image" <~~ json
        
        trip_latitude = "latitude" <~~ json
        trip_longitude = "longitude" <~~ json
        trip_title = "trip_title" <~~ json
        trip_description = "description" <~~ json
        friend_name = "friend_name" <~~ json
        friend_country = "friend_country" <~~ json
        friend_id = "friend_id" <~~ json

        invitedFriends = ("invitedFriends" <~~ json) ?? []
        tasks = ("taskDetails" <~~ json) ?? []
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "trip_id" ~~> trip_id,
            "id" ~~> ID,
            "country_id" ~~> country_id,
            "user_id" ~~> user_id,
            "user_name" ~~> user_name,
            "image" ~~> image,
            "description" ~~> tripDetails,
            "location_id" ~~> location_id,
            "completed" ~~> completed,
            "location_name" ~~> location_name,
            "avatar" ~~> avatar,
            "iso" ~~> iso,
            "iso3" ~~> iso3,
            "name" ~~> name,
            "nicename" ~~> nicename,

            "end_date" ~~> end_date,
            "start_date" ~~> start_date,

            "deleted_at" ~~> deleted_at,
            "created_at" ~~> created_at,
            "updated_at" ~~> updated_at,
            "full_name" ~~> full_name,
            "location_image" ~~> location_image,
            "latitude" ~~> trip_latitude,
            "longitude" ~~> trip_longitude,
            "trip_title" ~~> trip_title,
            "description" ~~> trip_description,
            "friend_name" ~~> friend_name,
            "friend_country" ~~> friend_country,
            "friend_id" ~~> friend_id,
            "invitedFriends" ~~> invitedFriends,
            "taskDetails" ~~> tasks
            ])
    }
    
    func tripDate() -> String {
        if let strtDate:String = start_date,let endDate:String = end_date{
            let fromDate = strtDate.toDateString(format: "yyyy-MM-dd")
            let toDate = endDate.toDateString(format: "yyyy-MM-dd")
            return "\(fromDate) - \(toDate)"
        }
        return ""
    }
}

class FeedBackModel: Glossy {
    
    var image: String?
    var video: String?
    
    
    required init?(json: Gloss.JSON) {
        image = "image" <~~ json
        video = "video" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "image" ~~> image,
            "video" ~~> video
            ])
    }
}

class ProductModel:NSObject, Glossy,MKAnnotation {

    var productId: Int?
    var sub_category_id: Int?
    var updated_at: String?
    var user_id: Int?
    
    var ptitle: String?
    var title: String?{
        return self.address
    }
    
    var lng: String?
    var make: String?
    var model: String?
    var lat: String?
    
    var image: String?
    var pdescription: String?
    var dealership: String?
    var created_at: String?
    var category_id: Int?
    var address: String?
    var user: UserModel?
    
    var subtitle: String? {
        return user?.user_name
    }
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: Double(self.lat ?? "0")!, longitude: Double(self.lng ?? "0")!)
    }
    
    required init?(json: Gloss.JSON) {
        
        productId = "id" <~~ json
        sub_category_id = "sub_category_id" <~~ json
        updated_at = "updated_at" <~~ json
        user_id = "user_id" <~~ json
        ptitle = "title" <~~ json

        model = "model" <~~ json
        make = "make" <~~ json
        lat = "lat" <~~ json
        lng = "long" <~~ json
        
        image = "image" <~~ json
        pdescription = "description" <~~ json
        dealership = "dealership" <~~ json
        created_at = "created_at" <~~ json
        category_id = "category_id" <~~ json
        address = "address" <~~ json
        user = "user" <~~ json
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> productId,
            "sub_category_id" ~~> sub_category_id,
            "updated_at" ~~> updated_at,
            "user_id" ~~> user_id,
            "title" ~~> ptitle,
            
            "model" ~~> model,
            "make" ~~> make,
            "long" ~~> lng,
            "lat" ~~> lat,
            
            "image" ~~> image,
            "description" ~~> pdescription,
            "dealership" ~~> dealership,
            "created_at" ~~> created_at,
            "category_id" ~~> category_id,
            "address" ~~> address,
            "user" ~~> user
            ])
    }
}

class BlogModel: Glossy {
    
    var blog_id: String?
    var avatar: String?
    var blog_title: String?
    var cover_photo: String?
    var created_at: String?
    var creator_country: String?
    var creator_name: String?
    var deleted_at: String?
    var blog_description: String?
    var image: String?
    var updated_at: String?
    var user_id: String?
    var video: String?
    var video_thumb: String?
    
    required init?(json: Gloss.JSON) {
        blog_id = "id" <~~ json
        avatar = "avatar" <~~ json
        blog_title = "blog_title" <~~ json
        cover_photo = "cover_photo" <~~ json
        created_at = "created_at" <~~ json
        creator_country = "creator_country" <~~ json
        creator_name = "creator_name" <~~ json
        deleted_at = "deleted_at" <~~ json
        blog_description = "description" <~~ json
        updated_at = "updated_at" <~~ json
        image = "image" <~~ json
        user_id = "user_id" <~~ json
        video = "video" <~~ json
        video_thumb = "video_thumb" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> blog_id,
            "avatar" ~~> avatar,
            "blog_title" ~~> blog_title,
            "cover_photo" ~~> cover_photo,
            "created_at" ~~> created_at,
            "creator_country" ~~> creator_country,
            "creator_name" ~~> creator_name,
            "deleted_at" ~~> deleted_at,
            "description" ~~> blog_description,
            "updated_at" ~~> updated_at,
            "user_id" ~~> user_id,
            "video" ~~> video,
            "image" ~~> image,
            "video_thumb" ~~> video_thumb,

            ])
    }
}

class BlogHistoryModel: Glossy {
    
    var blog_id: String?
    var avatar: String?
    var blog_title: String?
    var cover_photo: String?
    var created_at: String?
    var creator_country: String?
    var creator_name: String?
    var deleted_at: String?
    var blog_description: String?
    var image: String?
    var updated_at: String?
    var user_id: String?
    var video: String?
    var isFeedBack: Bool = false
    var video_thumb: String?
    

    var trip_id: String?
    var ID: String?
    var country_id: String?
    var user_name: String?
    var tripDetails: String?
    
    var location_id: String?
    var completed: Bool = false
    var location_name: String?
    var iso: String?
    var iso3: String?
    var name: String?
    var nicename: String?
    
    var start_date: String?
    var end_date: String?
    
    var full_name: String?
    var location_image: String?
    
    var trip_latitude: String?
    var trip_longitude: String?
    var trip_title: String?
    var trip_description: String?
    
    var invitedFriends:[UserModel] = []
    var tasks:[TaskModel] = []
    var friend_name: String?
    var friend_country: String?
    var friend_id: String?
    
    required init?(json: Gloss.JSON) {
        
        blog_id = "id" <~~ json
        avatar = "avatar" <~~ json
        blog_title = "blog_title" <~~ json
        cover_photo = "cover_photo" <~~ json
        created_at = "created_at" <~~ json
        creator_country = "creator_country" <~~ json
        creator_name = "creator_name" <~~ json
        deleted_at = "deleted_at" <~~ json
        blog_description = "description" <~~ json
        updated_at = "updated_at" <~~ json
        image = "image" <~~ json
        user_id = "user_id" <~~ json
        video = "video" <~~ json
        video_thumb = "video_thumb" <~~ json
        isFeedBack = "isFeedBack" <~~ json ?? false
        
        trip_id = "trip_id" <~~ json
        ID = "id" <~~ json
        country_id = "country_id" <~~ json
        user_id = "user_id" <~~ json
        user_name = "user_name" <~~ json
        image = "image" <~~ json
        tripDetails = "description" <~~ json
        location_id = "location_id" <~~ json
        avatar = "avatar" <~~ json
        completed = "completed" <~~ json ?? false
        
        location_name = "location_name" <~~ json
        iso = "iso" <~~ json
        iso3 = "iso3" <~~ json
        name = "name" <~~ json
        nicename = "nicename" <~~ json
        start_date = "start_date" <~~ json
        end_date = "end_date" <~~ json
        created_at = "created_at" <~~ json
        deleted_at = "deleted_at" <~~ json
        updated_at = "updated_at" <~~ json
        full_name = "full_name" <~~ json
        location_image = "location_image" <~~ json
        
        trip_latitude = "latitude" <~~ json
        trip_longitude = "longitude" <~~ json
        trip_title = "trip_title" <~~ json
        trip_description = "description" <~~ json
        friend_name = "friend_name" <~~ json
        friend_country = "friend_country" <~~ json
        friend_id = "friend_id" <~~ json
        
        invitedFriends = ("invitedFriends" <~~ json) ?? []
        tasks = ("taskDetails" <~~ json) ?? []
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> blog_id,
            "avatar" ~~> avatar,
            "blog_title" ~~> blog_title,
            "cover_photo" ~~> cover_photo,
            "created_at" ~~> created_at,
            "creator_country" ~~> creator_country,
            "creator_name" ~~> creator_name,
            "deleted_at" ~~> deleted_at,
            "description" ~~> blog_description,
            "updated_at" ~~> updated_at,
            "user_id" ~~> user_id,
            "video" ~~> video,
            "image" ~~> image,
            "video_thumb" ~~> video_thumb,
            "isFeedBack" ~~> isFeedBack,
            
            "trip_id" ~~> trip_id,
            "id" ~~> ID,
            "country_id" ~~> country_id,
            "user_id" ~~> user_id,
            "user_name" ~~> user_name,
            "image" ~~> image,
            "description" ~~> tripDetails,
            "location_id" ~~> location_id,
            "completed" ~~> completed,
            "location_name" ~~> location_name,
            "avatar" ~~> avatar,
            "iso" ~~> iso,
            "iso3" ~~> iso3,
            "name" ~~> name,
            "nicename" ~~> nicename,
            
            "end_date" ~~> end_date,
            "start_date" ~~> start_date,
            
            "deleted_at" ~~> deleted_at,
            "created_at" ~~> created_at,
            "updated_at" ~~> updated_at,
            "full_name" ~~> full_name,
            "location_image" ~~> location_image,
            "latitude" ~~> trip_latitude,
            "longitude" ~~> trip_longitude,
            "trip_title" ~~> trip_title,
            "description" ~~> trip_description,
            "friend_name" ~~> friend_name,
            "friend_country" ~~> friend_country,
            "friend_id" ~~> friend_id,
            "invitedFriends" ~~> invitedFriends,
            "taskDetails" ~~> tasks
            ])
    }
}
