//
//  DirectionModel
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Gloss
import SwiftyJSON
import CoreLocation
import GooglePlaces

class DirectionModel: Glossy {
    
    var geocoded_waypoints: [WaypointModel]?
    var routes: [RouteModel]?
    
    required init?(json: Gloss.JSON) {
        geocoded_waypoints = "geocoded_waypoints" <~~ json
        routes = "routes" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "geocoded_waypoints" ~~> geocoded_waypoints,
            "routes" ~~> routes
            ])
    }
}

class WaypointModel: Glossy {
    
    var place_id: String?
    
    required init?(json: Gloss.JSON) {
        place_id = "place_id" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "place_id" ~~> place_id,
            ])
    }
}

class RouteModel: Glossy {
    
    var overview_polyline: OverviewPolylineModel?
    
    required init?(json: Gloss.JSON) {
        overview_polyline = "overview_polyline" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "overview_polyline" ~~> overview_polyline
            ])
    }
}

class OverviewPolylineModel: Glossy {
    
    var points: String?
    var summary:String?
    
    required init?(json: Gloss.JSON) {
        points = "points" <~~ json
        summary = "summary" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "points" ~~> points,
            "summary" ~~> summary
            ])
    }
}
