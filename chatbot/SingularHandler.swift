//
//  SingularHandler.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/21.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation

class SingularHandler {
    
    func singlurize(word: String) -> String? {
        let inflector = TTTStringInflector.default()
        guard let singularizedWord = inflector?.singularize(word) else {
            print("error singularhandler")
            return nil
        }
        return singularizedWord
    }
    
    func pluralize(word: String) {
        let inflector = TTTStringInflector()
        inflector.pluralize(word)
    }
    
}
