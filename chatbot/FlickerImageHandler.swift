//
//  ImageHandler.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/15.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class FlickerImageHandler {
    
    
    let FLICKR_API_KEY:String = "your_api_key_here"
    let FLICKR_URL:String = "https://api.flickr.com/services/rest/"
    let SEARCH_METHOD:String = "flickr.photos.search"
    let FORMAT_TYPE:String = "json"
    let JSON_CALLBACK:Int = 1
    let PRIVACY_FILTER:Int = 1
    
    var imageString:String!

    func displayImage(searchText: String, handler: @escaping ((String) -> Void)) {
        
        let random = Int(arc4random_uniform(UInt32(100))) as Int
        
        let param = [
            "method": SEARCH_METHOD,
            "api_key": FLICKR_API_KEY,
            "tags": searchText,
            "privacy_filter":PRIVACY_FILTER,
            "format":FORMAT_TYPE,
            "nojsoncallback": JSON_CALLBACK
        ] as [String : Any]
        
        Alamofire.request(FLICKR_URL, method: .get, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            var innerJson:JSON = JSON(response)
            let farm:String = innerJson["photos"]["photo"][random]["farm"].stringValue
            let server:String = innerJson["photos"]["photo"][random]["server"].stringValue
            let photoID:String = innerJson["photos"]["photo"][random]["id"].stringValue
            let secret:String = innerJson["photos"]["photo"][random]["secret"].stringValue
            let imageString:String = "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_n.jpg/"
            handler(imageString)
        })
    }
}



