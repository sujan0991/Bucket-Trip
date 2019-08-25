//
//  HTTPManager
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

public func GMSRequest(
    _ method: HTTPMethod,
    _ urlString: String,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: [String: String]? = nil)
    -> DataRequest? {
        guard let fullUrl = URL(string: urlString, relativeTo: GMS_K.BaseURL) else {
            return nil
        }
        return request(fullUrl, method: method, parameters: parameters, encoding: encoding, headers: headers)
}
