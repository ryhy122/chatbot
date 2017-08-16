//
//  BubbleHistoryModel.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/17.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation

class BubbleHistoryModel {
    
    var typedWord:String
    var example: String?
    var definition: String?
    
    init(word: String, example: String?, definition: String?) {
        self.typedWord = word
        self.example = example
        self.definition = definition
    }
}
