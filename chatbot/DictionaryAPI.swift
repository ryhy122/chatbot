//
//  DictionaryAPI.swift
//  summaryBot
//
//  Created by 新井崚平 on 2017/06/10.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


private struct OxfordDictionaryKey {
    static let baseURL = "https://od-api.oxforddictionaries.com/api/v1/entries/"
    static let appId = "4b4e9c71"
    static let appKey = "1736764b8746a765791824b36f4459a6"
}

class DictionaryAPI {

    class func produceRequest(lang: String, searchWord: String) -> URLRequest? {
        if let url = URL(string: OxfordDictionaryKey.baseURL + "\(lang)/\(searchWord)") {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(OxfordDictionaryKey.appId, forHTTPHeaderField: "app_id")
            request.addValue(OxfordDictionaryKey.appKey, forHTTPHeaderField: "app_key")
            return request
        }
        return nil
    }

    class func searchDefinition(searchWord: String, language: String, completionHandler: @escaping ((String, [String], [String], Bool) -> Void)) {
        var _id = ""
        var exampleArray = [String]()
        var defArray = [String]()
        _ = searchWord.lowercased()
        
        guard let request = DictionaryAPI.produceRequest(lang: language, searchWord: searchWord) else {
            completionHandler("", ["I could not find definition of it. Can you try again, or another word?"],["not ready"], false)
            return
        }
        let session = URLSession.shared
        _ = session.dataTask(with: request, completionHandler: {
            data, response, error in
            if let _ = response, let responseData = data{
                
                let jsonParse = JSON(data: responseData)
                print(jsonParse)
                
                let results = jsonParse["results"].array
                results?.forEach({ (json) in
                    let lexicalEntries = json["lexicalEntries"].array
                    lexicalEntries?.forEach({ (lex) in
                        let entries = lex["entries"].array
                        entries?.forEach({ (senses) in
                            let examples = senses["senses"].array
                            examples?.forEach({ (jsondata) in
                               
                                let subsense = jsondata["subsenses"].array
                                subsense?.forEach({ (myjson) in
                                    let examp = myjson["examples"].array
                                    examp?.forEach({ (sometext) in
                                        guard let text = sometext["text"].string else {return}
                                        exampleArray.append(text)
                                    })
                                    
                                    let meaning = myjson["definitions"].array
                                    
                                    print(meaning)
                                    
                                    if meaning != nil {
                                        if (meaning?.count)! > 0 {
                                            if let string = meaning?.first?.rawString() {
                                                print("first object", string)
                                                defArray.append(string)
                                            }
                                        }
                                    } else {
                                        print("Error")
                                        completionHandler("", ["Something is wrong :/"], ["Hmmm example isnt ready"], false)
                                        return
                                    }
                                })
                                
                                guard let example = jsondata["examples"].array else {return}
                                example.forEach({ (text) in
                                    guard let myText = text["text"].string else {return}
                                    exampleArray.append(myText)
                                })
                                let jd = jsondata["definitions"].array
                                
                                if jd != nil {
                                    if (jd?.count)! > 0 {
                                        if let string = jd?.first?.rawString() {
                                            print("first object", string)
                                            defArray.append(string)
                                        }
                                    }
                                } else {
                                    completionHandler("", ["Something is wrong :/"], ["Hmmm example isnt ready"], false)
                                    return
                                    
                                }
                            
                            })
                        })
                    })
                })
                
                print(exampleArray)
                print(defArray)
                
                completionHandler(searchWord, defArray, exampleArray, true)
                
            } else {
                print("error")
                completionHandler("", ["Something is wrong :/"], ["Hmmm example isnt ready"], false)
//                print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            }
        }).resume()
    }

//    class func requestExampleSentences(searchWord: String, language: String, completionHandler: @escaping ((String, [String], Bool) -> Void)) {
//        var array = [String]()
//        var _id = ""
//        _ = searchWord.lowercased()
//        guard let request = DictionaryAPI.produceRequest(lang: language, searchWord: searchWord) else {
//            completionHandler("", ["I could not come up with any examples.. Hey, can I try again? "], false)
//            return
//        }
//        let session = URLSession.shared
//        _ = session.dataTask(with: request, completionHandler: { data, response, error in
//            
//        
//            if let _ = response, let responseData = data,
//                var jsonData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any] {
//                
//                if let data = jsonData?["results"] as? [[String: Any]] {
//                    for jsonDict in data {
//                        guard let id = jsonDict["id"] as? String else {return}
//                        _id = id
//                        guard let lexicalEntries = jsonDict["lexicalEntries"] as? [[String: Any]] else {return}
//                        for dict in lexicalEntries {
//                            guard let entries =  dict["entries"] as? [[String: Any]] else {return}
//                            for entry in entries {
//                                guard let senses = entry["senses"] as? [[String: Any]] else {return}
//                                for sense in senses {
//                                    guard let examples = sense["examples"] as? [[String:Any]] else { return }
//                                    for example in examples {
//                                        guard let sentence = example["text"] as? String else {return}
//                                        array.append(sentence)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                
//            } else {
//                print("error")
//                completionHandler("", ["I could not come up with any examples.. Hey, can I try again? "], false)
//                print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//            }
//        }).resume()
//    }

}
