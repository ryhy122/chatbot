//
//  VocabularyModel.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/17.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import UIKit


class Tag {
    var category: String
    init(category: String) {
        self.category = category
    }
}

class VocabularyModel {
    
    var word: String?
    var category: String?
    var image: UIImage?
    var label: String?
    
    init(word: String?, category: String?, image: UIImage?, label: String?) {
        self.word = word
        self.category = category
        self.image = image
        self.label = label
    }
    
}
