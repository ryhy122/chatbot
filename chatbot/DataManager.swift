//
//  DataManager.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/15.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    
    static let sharedInstance = DataManager()
    
    struct Key {
        static let chatbotName = "chatbotName"
        static let speekingSpeed = "speekingSpeed"
        static let readOutSentence = "readOutSentence"
        static let bubbleColor = "bubbleColor"
        static let notificationEnabled = "notificationEnabled"
        static let vocabularyTag = "vocabularyTag"
        static let phraseTag = "phraseTag"
    }
    
    let userDefault : UserDefaults! = UserDefaults.standard
    
    func saveVocabulary(tag: String) {
        userDefault.set(tag, forKey: Key.vocabularyTag)
    }
    
    func retrieveVocabulary() -> String? {
        if let name = userDefault.string(forKey: Key.vocabularyTag) {
            return name
        }
        
        return "#myVocabulary"
    }
    
    func savePhrase(tag: String) {
        userDefault.set(tag, forKey: Key.phraseTag)
    }
    
    func retrievePhrase() -> String {
        if let name = userDefault.string(forKey: Key.phraseTag) {
            return name
        }
        
        return "#myPhrase"
    }
    
    // ChatBot Name
    func set(chatotName: String) {
        userDefault.set(chatotName, forKey: Key.chatbotName)
    }
    
    func getName() -> String {
        if let name = userDefault.string(forKey: Key.chatbotName) {
            return name
        }
        return "default chatbot name"
    }
    
    
    func setSpeakingSpeed() {
    }
    func getSpeakingSpeed(){
    }
    
    func canReadSentence() -> Bool {
        return true
    }
    
    func changeBubble(color: UIColor) {
        
    }
    func getCurrentBubbleColor() -> UIColor {
        return UIColor.black
    }
    

}
