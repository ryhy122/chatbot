//
//  UserLanguage.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/08/07.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import UIKit


class UserLanguage {
    
    class func userlanguage(language: String) {
        
    }
    
    private func parseText(text: String) {
        let parsedText = LinguisticHandler().parse(text: text)
        print(parsedText)
    }
}
