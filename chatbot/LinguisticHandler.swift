//
//  LinguisticHandler.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/14.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import UIKit

class LinguisticHandler {
    
    struct LanguageDetector {
        static let notDetermined = "und"
        private let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeLanguage], options: 0)
        func detect(_ text: String) -> String {
            guard !text.isEmpty else {
                return LanguageDetector.notDetermined
            }
            tagger.string = text
            return tagger.tag(at: 0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil) ?? LanguageDetector.notDetermined
        }
    }
    
    func parse(text: String) -> String {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeLanguage], options: 0)
        tagger.string = text
        let result = tagger.tag(at: 0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil) ?? LanguageDetector.notDetermined
        return result
    }
    
    private func convert(languageCode: String) -> String {
//        switch languageCode {
//        case "de":
//            return "Denmark language"
//        case "en":
//            return "English language"
//        case "fr":
//            return "French language"
//        default:
//            print(languageCode)
//            break
//        }
        return languageCode
    }

}

