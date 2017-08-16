//
//  HashTagHandler.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/15.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel

class HashTagHandler {
    
    func createHashTag(text: String) -> ActiveLabel {
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.enabledTypes = [.mention, .hashtag, .url]
        label.text = text
        label.textColor = .black
        label.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
        }
        return label
    }
}
