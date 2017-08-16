//
//  chatbot.swift
//  JSQMessageDemo
//
//  Created by Ryohei on 2017/01/25.
//  Copyright © 2017年 bobby. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import UIKit


struct Chatbot {

    private let introductions = [
        "Hello. How are you feeling today?",
        "How do you do. Please tell me your problem.",
        "Please tell me what's been bothering you.",
        "Is something troubling you?"
    ]
    

    private let goodbyes = [
        "Goodbye. It was nice talking to you.",
        "Thank you for talking with me.",
        "Thank you, that will be $150. Have a good day!",
        "Thank you very much. I had a great time talking with you!!",
        "Goodbye. This was really a nice talk.",
        "Goodbye. I'm looking forward to our next session.",
        "Goodbye, my friend!! I hope I can talk to you soon later",
        "Come back later please! I like talking with you",
        "This was a good session, wasn't it – but time is over now. Goodbye.",
        "Maybe we could discuss this over more in our next session? Goodbye.",
        "Good-bye."
    ]
    
    private let psychobabble = [
        ("i need (.*)", [
            "Why do you need %s?",
            "Would it really help you to get %s?",
            "Are you sure you need %s?",
            "Okay, let me help ypu with %s",
            "What, you didn't have that? I thought you already had it"
            ]),
        ("why don'?t you ([^\\?]*)\\??", [
            "Do you really think I don't %s?",
            "Perhaps eventually I will %s.",
            "Do you really want me to %s?",
            "It is a good question."
            ]),
        ("why can'?t I ([^\\?]*)\\??", [
            "Do you think you should be able to %s?",
            "If you could %s, what would you do?",
            "I don't know -- why can't you %s?",
            "Have you really tried?",
            ]),
        ("i can'?t (.*)", [
            "How do you know you can't %s?",
            "Perhaps you could %s if you tried.",
            "What would it take for you to %s?",
            ]),
        ("i am (.*)", [
            "Did you come to me because you are %s?",
            "How long have you been %s?",
            "How do you feel about being %s?",
            ]),
        ("i'?m (.*)", [
            "How does being %s make you feel?",
            "Do you enjoy being %s?",
            "Why do you tell me you're %s?",
            "Why do you think you're %s?",
            ]),
        ("are you ([^\\?]*)\\??", [
            "Would you prefer it if I were not %s?",
            "Perhaps you believe I am %s.",
            "I may be %s -- what do you think?",
            "Yeah. Actually, yes."
            ]),
        ("what (.*)", [
            "Why do you ask?",
            "How would an answer to that help you?",
            "What do you think?",
            ]),
        ("how (.*)", [
            "How do you suppose?",
            "Perhaps you can answer your own question.",
            "What is it you're really asking?",
            "It depends on each person, but I would say more study is necessary"
            ]),
        ("because (.*)", [
            "Is that the real reason?",
            "What other reasons come to mind?",
            "Does that reason apply to anything else?",
            "If %s, what else must be true?",
            ]),
        ("(.*) sorry (.*)", [
            "There are many times when no apology is needed.",
            "What feelings do you have when you apologize?",
            "Noooo, don't appoligize to me. It is fine :)"
            ]),
        ("^hello(.*)", [
            "Hello!! I'm glad you could drop by today.",
            "Hi there... how are you today?",
            "Hello, how are you feeling today?",
            "Hey there! What are yo doing now :)"
            ]),
        ("^hi(.*)", [
            "Hello... I'm glad you could drop by today.",
            "Hi there... how are you today?",
            "Hello, how are you feeling today?",
            "Yo!"
            ]),
        ("^thanks(.*)", [
            "You're welcome!",
            "Anytime!",
            "Np! I am happy I could help you!"
            ]),
        ("^thank you(.*)", [
            "You're welcome!",
            "Anytime!",
            "Np! I am happy I could help you!"
            ]),
        ("^good morning(.*)", [
            "Good morning... I'm glad you could drop by today.",
            "Good morning... how are you today?",
            "Good morning, how are you feeling today?",
            ]),
        ("^good afternoon(.*)", [
            "Good afternoon... I'm glad you could drop by today.",
            "Good afternoon... how are you today?",
            "Good afternoon, how are you feeling today?",
            ]),
        ("I think (.*)", [
            "Do you doubt %s?",
            "Do you really think so?",
            "But you're not sure %s?",
            ]),
        ("(.*) friend (.*)", [
            "Tell me more about your friends.",
            "When you think of a friend, what comes to mind?",
            "Why don't you tell me about a childhood friend?",
            ]),
        ("vocabulary", [
            "Vocabulary is hard to memorize. But that's why I am here for you!",
            "If you add more vocabulary, I will learn that vocabulary too. Let's memorize vocabulary together!",
            ]),
        ("yes", [
            "You seem quite sure.",
            "OK, but can you elaborate a bit?",
            ]),
        ("(.*) computer(.*)", [
            "Are you really talking about me?",
            "Does it seem strange to talk to a computer?",
            "How do computers make you feel?",
            "Do you feel threatened by computers?",
            ]),
        ("is it (.*)", [
            "Do you think it is %s?",
            "Perhaps it's %s -- what do you think?",
            "If it were %s, what would you do?",
            "It could well be that %s.",
            ]),
        ("it is (.*)", [
            "You seem very certain.",
            "If I told you that it probably isn't %s, what would you feel?",
            ]),
        ("can you ([^\\?]*)\\??", [
            "What makes you think I can't %s?",
            "If I could %s, then what?",
            "Why do you ask if I can %s?",
            ]),
        ("(.*)dream(.*)", [
            "Tell me more about your dream.",
            ]),
        ("can I ([^\\?]*)\\??", [
            "Perhaps you don't want to %s.",
            "Do you want to be able to %s?",
            "If you could %s, would you?",
            ]),
        ("you are (.*)", [
            "Why do you think I am %s?",
            "Does it please you to think that I'm %s?",
            "Perhaps you would like me to be %s.",
            "Perhaps you're really talking about yourself?",
            ]),
        ("you'?re (.*)", [
            "Why do you say I am %s?",
            "Why do you think I am %s?",
            "Are we talking about you, or me?",
            ]),
        ("i don'?t (.*)", [
            "Don't you really %s?",
            "Why don't you %s?",
            "Do you want to %s?",
            ]),
        ("i feel (.*)", [
            "Good, tell me more about these feelings.",
            "Do you often feel %s?",
            "When do you usually feel %s?",
            "When you feel %s, what do you do?",
            ]),
        ("i have (.*)", [
            "Why do you tell me that you've %s?",
            "Have you really %s?",
            "Now that you have %s, what will you do next?",
            ]),
        ("i would (.*)", [
            "Could you explain why you would %s?",
            "Why would you %s?",
            "I would like %s too. But I can't do that...I wish I could though",
            "Who else knows that you would %s?",
            ]),
        ("is there (.*)", [
            "Hmm.. I have no idea. I am worse than Google...",
            "It's likely that there is %s around here. I am sure",
            "Would you like there to be %s?",
            "Maybe...have you already tried to find it?"
            ]),
        ("my (.*)", [
            "I see. Your %s is kinda amazing.",
            "Why do you say that your %s?",
            "When your %s, how do you feel?",
            ]),
        ("you (.*)", [
            "We should be discussing you, not me.",
            "Why do you say that to me?",
            "Why do you care whether I %s?. I am just here to help you",
            ]),
        ("why (.*)", [
            "Why don't you tell me the reason why %s?",
            "Why do you think %s?",
            "Who knows",
            "Well, I think it is because.... sorry I don't know"
            ]),
        ("i want (.*)", [
            "What would it mean to you if you got %s?",
            "Why do you want %s?",
            "What would you do if you got %s?",
            "If you got %s, then what would you do?",
            ]),
        ("(.*) mother(.*)", [
            "Tell me more about your mother.",
            "What was your relationship with your mother like?",
            "How do you feel about your mother?",
            "How does this relate to your feelings today?",
            "Good family relations are important.",
            ]),
        ("(.*) father(.*)", [
            "Tell me more about your father.",
            "How did your father make you feel?",
            "How do you feel about your father?",
            "Does your relationship with your father relate to your feelings today?",
            "Do you have trouble showing affection with your family?",
            ]),
        ("(.*) child(.*)", [
            "Did you have close friends as a child?",
            "What is your favorite childhood memory?",
            "Do you remember any dreams or nightmares from childhood?",
            "Did the other children sometimes tease you?",
            "How do you think your childhood experiences relate to your feelings today?",
            ]),
        ("(.*)\\?", [
            "Why do you ask that?",
            "Please consider whether you can answer your own question.",
            "Perhaps the answer lies within yourself?",
            "Why don't you tell me?",
            ])
    ]

    private let defaultResponses = [
        "Please tell me more.",
        "Do you remember words you store? Please enjoy this app! I am happy if you find me useful!!",
        "I see!!",
        "Interesting!!",
        "I am here to assist you to memorize more voabulary!",
        "How do you memorize vocabulary?"
        ]
    

    private let quitStatements = [
        "goodbye",
        "bye",
        "quit",
        "exit",
        ]
    
    private let reflectedWords = [
        "am": "are",
        "was": "were",
        "i": "you",
        "i'd": "you would",
        "i've": "you have",
        "i'll": "you will",
        "my": "your",
        "are": "am",
        "you've": "I have",
        "you'll": "I will",
        "your": "my",
        "yours": "mine",
        "you": "me",
        "me": "you"
    ]
    
    
    func elizaHi() -> String {
        return introductions.randChoice()
    }
    
    
    func elizaBye() -> String {
        return goodbyes.randChoice()
    }
    
    func replyTo(_ statement: String) -> String {
        var statement = preprocess(statement)
        if quitStatements.contains(statement)  {
            return elizaBye()
        }
        
        for (pattern, responses) in psychobabble {
            // Apply the regex re to the statement string
            let re = try! NSRegularExpression(pattern: pattern)
            let matches = re.matches(in: statement, range: NSRange(location: 0, length: statement.characters.count))
            
            // If the statement matched any recognizable statements
            if matches.count > 0 {
                // There should only be one match
                let match = matches[0]
                
                // If we matched a regex capturing group in parentheses, get the first one.
                // The matched regex group will match a "fragment" that will form
                // part of the response, for added realism.
                var fragment = ""
                if match.numberOfRanges > 1 {
                    fragment = (statement as NSString).substring(with: match.rangeAt(1))
                    fragment = reflect(fragment)
                }
                
                // Choose a random appropriate response, and format it with the
                // fragment, if needed.
                var response = responses.randChoice()
                response = response.replacingOccurrences(of: "%s", with: fragment)
                return response
            }
        }
        
        // If no patterns were matched, return a default response.
        return defaultResponses.randChoice()
    }

    private func preprocess(_ statement: String) -> String {
        let trimmed = statement.trimmingCharacters(in: .whitespacesAndNewlines)
        let lowercased = trimmed.lowercased()
        return lowercased
    }

    private func reflect(_ fragment: String) -> String {
        var words = fragment.components(separatedBy: " ")
        for (i, word) in words.enumerated() {
            if let reflectedWord = reflectedWords[word] {
                words[i] = reflectedWord
            }
        }
        return words.joined(separator: " ")
    }
}

// Add a randChoice method to Array's, which returns a random element.
extension Array {
    func randChoice() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
