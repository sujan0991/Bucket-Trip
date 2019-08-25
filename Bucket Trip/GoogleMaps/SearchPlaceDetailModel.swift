//
//  SearchPlaceDetailModel.swift
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Gloss
import SwiftyJSON
import CoreLocation

class SearchPlaceDetailModel: Glossy {
    
    var formatted_address: String?
    var geometry: GeometryModel?
   
    required init?(json: Gloss.JSON) {
        formatted_address = "formatted_address" <~~ json
         geometry = "geometry" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "formatted_address" ~~> formatted_address,
            "geometry" ~~> geometry
            ])
    }
}

class GeometryModel: Glossy {
    
    var location: PlaceModel?
    
    required init?(json: Gloss.JSON) {
        location = "location" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "location" ~~> location
            ])
    }
}
class PlaceModel: Glossy {
    
    var lat: Double?
    var lng: Double?
    
    required init?(json: Gloss.JSON) {
        lat = "lat" <~~ json
        lng = "lng" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "lat" ~~> lat,
            "lng" ~~> lng
            ])
    }
}
