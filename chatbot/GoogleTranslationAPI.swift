//
//  GoogleTranslationAPI.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/21.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import UIKit
import ROGoogleTranslate

class GoogleTranslationAPI {
    
    func trasnlate(_ from: String, to: String, text: String, completionHandler: @escaping ((String) -> Void)) {
        let translator = ROGoogleTranslate()
        translator.apiKey = "AIzaSyCA_rFsbNICtHdaXUDabvyacZ8hUGOkqTU" // Add your API Key here
        
        var params = ROGoogleTranslateParams()
        params.source = from
        params.target = to
        params.text = text
        
        translator.translate(params: params) { (result) in
            print("Translation: \(result)")
            completionHandler(result)
        }
    }
    
    
}
