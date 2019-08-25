//
//  SearchPlaceModel.swift
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Gloss
import SwiftyJSON
import CoreLocation



class PlaceTermModel: Glossy {
    
    open let offset: String?
    open let value: String?
    
    required init?(json: Gloss.JSON) {
        offset = "offset" <~~ json
        value = "value" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "offset" ~~> offset,
            "value" ~~> value
            ])
    }
}

class PlaceDescriptionModel: Glossy {
    
    var  pDescription: String?
    
    required init?(json: Gloss.JSON) {
        pDescription = "description" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "description" ~~> pDescription,
            ])
    }
}

class StructuredFormattingModel: Glossy {
    
    var  main_text: String?
    var  secondary_text: String?
    
    required init?(json: Gloss.JSON) {
        main_text = "main_text" <~~ json
        secondary_text = "secondary_text" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "main_text" ~~> main_text,
            "secondary_text" ~~> secondary_text
            ])
    }
    
    func getState()-> String {
        guard let detail:String = secondary_text else{
            return ""
        }
        if let desA = detail.components(separatedBy: ",").first{
            return desA
        }
        return detail
    }
    
    func displayName() ->String  {
        var txt = ""
        if let state = secondary_text{
            txt = state
        }
        if let city1 = main_text{
            txt = "\(city1)-\(txt)"
        }
       
        return txt
    }
}
