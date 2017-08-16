//
//  RegisteringUserInfo.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/21.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation

class RegisteringUserInfo {
    
    var name: String
    var userLanguage: String
    var learningLanguage: String
    
    init(name: String, userLang: String, learningLang: String) {
        self.name = name
        self.userLanguage = userLang
        self.learningLanguage = learningLang
    }
}
